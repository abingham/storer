require_relative 'test_base'
require_relative 'spy_logger'
require_relative '../../src/all_avatars_names'

class StorerCompletionTest < TestBase

  def self.hex_prefix
    '36E4A'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C1C',
  'completed with invalid kata_id raises' do
    invalid_partial_ids = [
      nil,          # not an object
      [],           # not a string
      'X4',         # not hex chars
    ].each do |invalid_partial_id|
      error = assert_raises(ArgumentError) {
        storer.completed(invalid_partial_id)
      }
      assert error.message.end_with?('invalid kata_id'), error.message
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '42E',
  'completed(id) does not complete when id is less than 6 chars in length',
  'because trying to complete from a short id will waste time going through',
  'lots of candidates (on disk) with the likely outcome of no unique result' do
    id = kata_id[0..4]
    assert_equal 5, id.length
    assert_equal id, storer.completed(id)
  end

  test '071',
  'completed(id) unchanged when no matches' do
    id = kata_id
    (0..7).each { |size| assert_equal id[0..size], storer.completed(id[0..size]) }
  end

  test '23B',
  'completed(id) does not complete when 6+ chars and more than one match' do
    uncompleted_id = kata_id[0..5]
    make_kata(uncompleted_id + '234' + '5')
    make_kata(uncompleted_id + '234' + '6')
    assert_equal uncompleted_id, storer.completed(uncompleted_id)
  end

  test '093',
  'completed(id) completes when 6+ chars and 1 match' do
    completed_id = kata_id
    make_kata(completed_id)
    uncompleted_id = completed_id[0..5]
    assert_equal completed_id, storer.completed(uncompleted_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '35C',
  'ids_for(outer) zero matches' do
    assert_equal [], storer.completions('C5')
  end

  test '0D6',
  'ids_for(outer) returns inner-dirs, one match' do
    kata_id = '0D6E4FDA26'
    make_kata(kata_id)
    assert_equal [inner(kata_id)], storer.completions('0D')
  end

  test 'A03',
  'ids_for(outer) returns inner-dirs, two close matches' do
    kata_ids = [ 'A03E4FDA20', 'A03E4FDA21' ]
    kata_ids.each { |id| make_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.completions('A0').sort
  end

  test '7FC',
  'ids_for(outer) returns inner-dirs, three far matches' do
    kata_ids = [ '7FC2034534', '7FD92F11B0', '7F13E86582' ]
    kata_ids.each { |id| make_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.completions('7F').sort
  end

end
