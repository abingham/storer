require 'simplecov'

cov_root = File.expand_path('..', File.dirname(__FILE__))

SimpleCov.start do
  #add_group('debug') { |src| print src.filename+"\n"; false }
  add_filter 'test/src/storer_posix_fs_test.rb'  # contains Process.fork calls!
  add_group('src')      { |src|
    src.filename.start_with? "#{cov_root}/src"
  }
  add_group('test/src') { |src|
    src.filename.start_with? "#{cov_root}/test/src"
  }
end

SimpleCov.root cov_root
SimpleCov.coverage_dir ENV['CYBER_DOJO_COVERAGE_ROOT']
