require_relative 'test_base'

class StorerPosixFsTest < TestBase

  def self.hex_prefix
    '701B5'
  end

  test '4C0',
  'start_avatar on multiple threads doesnt start the same avatar twice' do
    20.times do |n|
      kata_id = make_kata
      started = []
      size = 4
      animals = all_avatars_names.shuffle[0...size]
      threads = Array.new(size * 2)
      names = []
      threads.size.times { |i|
        threads[i] = Thread.new {
          name = storer.start_avatar(kata_id, animals)
          names << name unless name.nil?
        }
      }
      threads.size.times { |i| threads[i].join }
      assert_equal animals.sort, names.sort
      assert_equal names.sort, storer.started_avatars(kata_id).sort
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A31',
  'start_avatar on multiple processes doesnt start the same avatar twice' do
    20.times do |n|
      kata_id = make_kata
      started = []
      size = 4
      animals = all_avatars_names.shuffle[0...size]
      pids = Array.new(size * 2)
      read_pipe, write_pipe = IO.pipe
      pids.size.times { |i|
        pids[i] = Process.fork {
          name = storer.start_avatar(kata_id, animals)
          write_pipe.puts "#{name} " unless name.nil?
        }
      }
      pids.each { |pid| Process.wait(pid) }
      write_pipe.close
      names = read_pipe.read.split
      read_pipe.close
      assert_equal animals.sort, names.sort
      assert_equal names.sort, storer.started_avatars(kata_id).sort
    end
  end

end
