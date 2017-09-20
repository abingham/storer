
def all_tests?
  ARGV[2..-1] == []
end

def number
  '[\.|\d]+'
end

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def cleaned(s)
  # guard against invalid byte sequence
  s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
  s = s.encode('UTF-8', 'UTF-16')
end

def get_index_stats(flat, name)
  html = `cat #{ARGV[1]}`
  html = cleaned(html)
  pattern = /<div class=\"file_list_container\" id=\"#{flat}\">
  \s*<h2>\s*<span class=\"group_name\">#{name}<\/span>
  \s*\(<span class=\"covered_percent\"><span class=\"\w+\">([\d\.]*)\%<\/span><\/span>
  \s*covered at
  \s*<span class=\"covered_strength\">
  \s*<span class=\"\w+\">
  \s*(#{number})
  \s*<\/span>
  \s*<\/span> hits\/line\)
  \s*<\/h2>
  \s*<a name=\"#{flat}\"><\/a>
  \s*<div>
  \s*<b>#{number}<\/b> files in total.
  \s*<b>(#{number})<\/b> relevant lines./m
  r = html.match(pattern)
  {
         coverage: f2(r[1]),
    hits_per_line: f2(r[2]),
       line_count:    r[3].to_i,
             name: name
  }
end

# - - - - - - - - - - - - - - - - - - - - - - -

def get_test_log_stats
  comma_space = ', '
  test_log = `cat #{ARGV[0]}`
  test_log = cleaned(test_log)

  finished_pattern = [
    "Finished in (#{number})s",
    "(#{number}) runs/s",
    "(#{number}) assertions/s"
  ].join(comma_space)
  m = test_log.match(Regexp.new(finished_pattern))

  stats = {}
  stats[:time]               = f2(m[1])
  stats[:tests_per_sec]      =    m[2].to_i
  stats[:assertions_per_sec] =    m[3].to_i

  headings = %w(runs assertions failures errors skips)
  summary_pattern = headings.map{ |s| "(#{number}) #{s}" }.join(comma_space)
  m = test_log.match(Regexp.new(summary_pattern))

  stats[:test_count]      = m[1].to_i
  stats[:assertion_count] = m[2].to_i
  stats[:failure_count]   = m[3].to_i
  stats[:error_count]     = m[4].to_i
  stats[:skip_count]      = m[5].to_i

  stats
end

# - - - - - - - - - - - - - - - - - - - - - - -

def done(options, *table)
  results = []
  table.each do |name, value, op, limit|
    result = eval("#{value} #{op} #{limit}")
    if options[:show_fails] && !result
      puts "%s | %s %s %s | %s" % [
        name.rjust(25),
        value.to_s.rjust(7),
        op,
        limit.to_s.rjust(3),
        result.to_s
      ]
    end
    results << result
  end
  results
end

# - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - -

 log_stats = get_test_log_stats
test_stats = get_index_stats('testsrc', 'test/src')
 src_stats = get_index_stats('src', 'src')

# - - - - - - - - - - - - - - - - - - - - - - -

failure_count = log_stats[:failure_count]
  error_count = log_stats[:error_count  ]
   skip_count = log_stats[:skip_count   ]

          duration = log_stats[:time].to_f
assertions_per_sec = log_stats[:assertions_per_sec].to_i

 src_coverage =  src_stats[:coverage].to_f
test_coverage = test_stats[:coverage].to_f

 src_hits_per_line =  src_stats[:hits_per_line].to_f
test_hits_per_line = test_stats[:hits_per_line].to_f

line_ratio = (test_stats[:line_count].to_f / src_stats[:line_count].to_f)

# - - - - - - - - - - - - - - - - - - - - - - -

critical = done({show_fails:true},
    [ 'failures',                failure_count, '==',   0 ],
    [ 'errors',                    error_count, '==',   0 ],
)

metrics = done({show_fails:all_tests?},
    [ 'skips',                      skip_count, '==',   0 ],

    [ 'assertions/sec',     assertions_per_sec, '>=',  25 ],
    [ 'duration[sec]',                duration, '<=',  20 ],

    [ ' (src)coverage[%]',        src_coverage, '==', 100 ],
    [ '(test)coverage[%]',       test_coverage, '==', 100 ],

    [ ' (src)hits/line',     src_hits_per_line, '<=', 250 ],
    [ '(test)hits/line',    test_hits_per_line, '<=',  10 ],

    [ 'lines(test)/lines(src)', f2(line_ratio), '>=', 1.9 ],
)

# - - - - - - - - - - - - - - - - - - - - - - -

if all_tests?
  exit critical.all? && metrics.all?
else
  exit critical.all?
end
