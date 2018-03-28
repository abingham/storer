require_relative '../../src/base58'
require_relative 'id_generator_stub'

class KataIdGeneratorTest < TestBase

  def self.hex_prefix
    '79B84'
  end

  # - - - - - - - - - - - - - - - -

  test '926',
  'generates a valid kata-id' do
    42.times do
      kata_id = kata_id_generator.generate
      assert Base58.string?(kata_id)
    end
  end

  # - - - - - - - - - - - - - - - -

  test '927',
  'you can stub the lower level generated-id' do
    external.id_generator = IdGeneratorStub.new
    id_generator.stub(test_id)
    assert_equal test_id, kata_id_generator.generate
  end

  # - - - - - - - - - - - - - - - -

  test '928',
  'thus you can stub the kata-id generated in storer.kata_create' do
    external.id_generator = IdGeneratorStub.new
    id_generator.stub(test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '929',
  'discards generated kata-ids that are invalid' do
    external.id_generator = IdGeneratorStub.new
    id_generator.stub('invalid', test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '930',
  'discards generated kata-ids that already exist' do
    external.id_generator = IdGeneratorStub.new
    id = make_kata
    id_generator.stub(id, test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test 'ABC',
  'discards generated kata-ids that are not completable ' do
    #...
  end

end