require_relative 'test_base'

class StorerCompletionTest < TestBase

  def self.hex_prefix
    '36E4A'
  end

  def hex_setup
    @old_env_var = ENV['CYBER_DOJO_KATAS_ROOT']
    # these tests must be completely isolated from each other
    ENV['CYBER_DOJO_KATAS_ROOT'] = "/tmp/cyber-dojo/#{test_id}/katas"
  end

  def hex_teardown
    ENV['CYBER_DOJO_KATAS_ROOT'] = @old_env_var
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas_completed()
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '42E',
  'katas_completed(id) is empty-string when id is less than 6 chars in length',
  'because trying to complete from a short id will waste time going through',
  'lots of candidates (on disk) with the likely outcome of no unique result' do
    kata_id = make_kata
    5.times do |n|
      partial_id = kata_id[0...n]
      assert_equal n, partial_id.length
      assert_equal '', katas_completed(partial_id)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '071',
  'katas_completed(id) is empty-string when no matches' do
    id = test_id
    (0..7).each do |size|
      partial_id = id[0..size]
      assert_equal '', katas_completed(partial_id)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '23B',
  'katas_completed(id) is empty-string when 6+ chars and more than one match' do
    partial_id = 'B05DE4782'
    assert_equal 9, partial_id.size
    kata_ids = [ partial_id+'5', partial_id+'6' ]
    stubbed_make_katas(kata_ids)
    assert_equal '', katas_completed(partial_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '093',
  'katas_completed(id) completes when 6+ chars and 1 match' do
    kata_id = make_kata
    partial_id = kata_id[0..5]
    assert_equal kata_id, katas_completed(partial_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas_completions()
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A03',
  'ids_for(outer) returns inner-dirs, two close matches' do
    kata_ids = %w( A03E4FDA20 A03E4FDA21 )
    stubbed_make_katas(kata_ids)
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, katas_completions('A0').sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7FC',
  'ids_for(outer) returns inner-dirs, three far matches' do
    kata_ids = %w( 7FC2034534 7FD92F11B0 7F13E86582 )
    stubbed_make_katas(kata_ids)
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, katas_completions('7F').sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '35C',
  'ids_for(outer) zero matches' do
    assert_equal [], katas_completions('C5')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0D6',
  'ids_for(outer) returns inner-dirs, one match' do
    id = make_kata
    assert_equal [inner(id)], katas_completions(id[0..1])
  end

  private

  def stubbed_make_katas(kata_ids)
    external.id_generator = IdGeneratorStub.new
    id_generator.stub(*kata_ids)
    kata_ids.size.times { make_kata }
  end

end
