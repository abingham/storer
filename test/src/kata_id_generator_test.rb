require_relative '../../src/base58'
require_relative '../../src/id_generator'
require_relative 'id_generator_stub'

class KataIdGeneratorTest < TestBase

  def self.hex_prefix
    '79B84'
  end

  def hex_setup
    external.id_generator = IdGeneratorStub.new
  end

  # - - - - - - - - - - - - - - - -

  test '926',
  'generates a valid kata-id' do
    external.id_generator = IdGenerator.new
    42.times do
      kata_id = kata_id_generator.generate
      assert Base58.string?(kata_id)
    end
  end

  # - - - - - - - - - - - - - - - -

  test '927',
  'you can stub the lower level generated-id' do
    id_generator.stub(test_id)
    assert_equal test_id, kata_id_generator.generate
  end

  # - - - - - - - - - - - - - - - -

  test '928',
  'thus you can stub the kata-id generated in storer.kata_create' do
    id_generator.stub(test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '929',
  'discards generated kata-ids that are invalid' do
    id_generator.stub('invalid', test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '930',
  'discards generated kata-ids that already exist' do
    id = make_kata
    id_generator.stub(id, test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '931',
  'discards generated kata-ids that include lowercase ell' do
    id_generator.stub('0a1bll3d4e', test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

  # - - - - - - - - - - - - - - - -

  test '932',
  'discards generated kata-ids that include uppercase ell' do
    id_generator.stub('0a1bLL3d4e', test_id)
    assert_equal test_id, storer.kata_create(create_manifest)
  end

end