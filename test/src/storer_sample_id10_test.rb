require_relative 'test_base'

class StorerSampleId10Test < TestBase

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
    kata_ids = %w( 7FC2034534 7FD92F11B0 7F13E86582 )
    stubbed_make_katas(kata_ids)
    counts = Hash[kata_ids.map { |id| [id,0] }]
    (0..42).each { counts[storer.sample_id10] += 1 }
    counts.each do |kata_id,count|
      assert count > 0, "#{kata_id}->#{count}"
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def stubbed_make_katas(kata_ids)
    external.id_generator = IdGeneratorStub.new
    id_generator.stub(*kata_ids)
    kata_ids.size.times { make_kata }
  end

end
