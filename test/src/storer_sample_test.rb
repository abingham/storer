require_relative 'test_base'

class StorerSampleTest < TestBase

  def self.hex_prefix
    'B564B'
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

  test '1DF',
  'sample_id10_returns_a_randomly_selected_10_digit_kata_id' do
    # test rig has inserted katas named 'old/red' 42.. 1F.. 5A..
    sampled = 1000.times.collect { storer.sample_id10 }.sort.uniq
    assert sampled.include?('420BD5D5BE'), 'did not sample 420BD5D5BE'
    assert sampled.include?('1F00C1BFC8'), 'did not sample 1F00C1BFC8'
    assert sampled.include?('5A0F824303'), 'did not sample 5A0F824303'
    assert sampled.include?('7E53732F00'), 'did not sample 7E53732F00'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2DF',
  'sample_id2_returns_a_randomly_selected_2_digit_outer_id' do
    # test rig has inserted katas named 'old/red' 42.. 1F.. 5A..
    sampled = 1000.times.collect { storer.sample_id2 }.sort.uniq
    assert sampled.include?('42'), 'did not sample 42'
    assert sampled.include?('1F'), 'did not sample 1F'
    assert sampled.include?('5A'), 'did not sample 5A'
    assert sampled.include?('7E'), 'did not sample 7E'
  end

end
