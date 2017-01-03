require 'simplecov'

cov_root = File.expand_path('..', File.dirname(__FILE__))

SimpleCov.start do
  # done from client container
  add_filter 'src/micro_service.rb'
  # contains Process.fork calls!
  add_filter 'test/src/storer_posix_fs_test.rb'

  add_group 'src',      "#{cov_root}/src"
  add_group 'test/src', "#{cov_root}/test/src"
end

SimpleCov.root cov_root
SimpleCov.coverage_dir '/tmp/coverage'