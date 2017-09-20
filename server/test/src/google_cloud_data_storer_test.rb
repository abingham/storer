require_relative 'test_base'
require_relative 'spy_logger'
require_relative '../../src/all_avatars_names'
require 'google/cloud/datastore'

# TODO: create two buckets, one with Object versioning, one without

class GoogleCloudDataStorerSpike

  def initialize
    project_id = 'cyber-dojo'
    @datastore = Google::Cloud::Datastore.new project: project_id
  end

  attr_reader :datastore

end

class GoogleCloudDataStorerTest < TestBase

  def self.hex_prefix; '2B1E8DF'; end

  def datastore
    GoogleCloudDataStorerSpike.new.datastore
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '024',
  'you can create a kata with a new id which then exists' do
    id = '1993E04534'
    refute kata_exists? id
    assert kata_create id
    begin
      assert kata_exists? id
    ensure
      kata_delete id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '025',
  'you can delete an existing kata which then does not exist' do
    id = 'A9D539F54D'
    kata_create id
    kata_delete id
    refute kata_exists? id
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '026',
  'you cant create a kata with an existing id' do
    id = 'C16A458801'
    assert kata_create id
    begin
      refute kata_create id
    ensure
      kata_delete id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def kata_create(id, manifest="{...json-for-#{kata_id}-here...}")
    kata = datastore.entity 'kata', id do |e|
      e['manifest'] = manifest
      e['key_prefix'] = id[0..5] # for completion
    end
    datastore_create(kata)
  end

  def kata_delete(id)
    datastore_delete 'kata', id
  end

  def kata_exists?(id)
    key = datastore.key ['kata', id]
    datastore.find key
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def datastore_create(entity)
    result = nil
    datastore.transaction do |tx|
      if tx.find(entity.key).nil?
        tx.save entity
        result = true # created and didn't exist before
      else
        result = false # already exists
      end
    end
    result
  end

  def datastore_delete(*params)
    key = datastore.key *params
    r = datastore.delete key
    # r is always true
  end

  # - - - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - - - -

  test '027',
  'you can create an avatar with a new name which then exists' do
    id = '3BB113678E'
    refute avatar_exists? id, lion
    assert avatar_create id, lion
    begin
      assert avatar_exists? id, lion
    ensure
      avatar_delete id, lion
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '028',
  'you can delete an existing avatar which then does not exist' do
    id = 'DDCEF1BE7B'
    avatar_create id, lion
    avatar_delete id, lion
    refute avatar_exists? id, lion
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '029',
  'you cant create an avatar with an existing name' do
    id = 'DFFE91A2C8'
    assert avatar_create id, lion
    begin
      refute avatar_create id, lion
    ensure
      avatar_delete id, lion
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '02A',
  'completing a 6-digit kata-id to one 10-digit id' do
    id = '4B80741C3C'
    kata_create id
    begin
      key_prefix = id[0..5]
      query = datastore.query('kata').where('key_prefix', '=', key_prefix)
      all = datastore.run(query).to_a
      assert_equal 1, all.size
      assert_equal id, all[0].key.name
    ensure
      kata_delete id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '02B',
  'completing a 6-digit kata-id to two 10-digit ids' do
    key_prefix = '7658BC'
    id1 = key_prefix + '1C3C'
    kata_create id1
    id2 = key_prefix + '4DE5'
    kata_create id2
    begin
      query = datastore.query('kata').where('key_prefix', '=', key_prefix)
      all = datastore.run(query).to_a
      assert_equal 2, all.size
      assert_equal [id1,id2], all.map{ |e| e.key.name }
    ensure
      kata_delete id1
      kata_delete id2
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_create(id, name)
    avatar = datastore.entity [['kata', id], ['avatar', name]] do |e|
      e['increments'] = '[]'
    end
    datastore_create(avatar)
  end

  def avatar_delete(id, name)
    datastore_delete('kata', id, 'avatar', name)
  end

  def avatar_exists?(id, name)
    key = datastore.key [['kata', id], ['avatar', name]]
    datastore.find key
  end

  def lion
    'lion'
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '030',
  'atomically update an avatars increments' do
    id = 'B7FAA22CCB'
    avatar_create id, lion
    begin
      key = datastore.key [['kata', id], ['avatar', lion]]
      datastore.transaction do |tx|
        avatar = tx.find key
        rags = JSON.parse(avatar['increments'])
        rags << 'red'
        avatar['increments'] = JSON.unparse(rags)
        datastore.save avatar
      end
      avatar = avatar_exists? id, lion
      refute_nil avatar
      rags = JSON.parse(avatar['increments'])
      assert_equal ['red'], rags
    ensure
      avatar_delete id, lion
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '031',
  'read based on key' do
    id = '65CFFFEC38'
    avatar_create id, lion
    begin
      avatar = avatar_exists? id, lion
      refute_nil avatar
      rags = JSON.parse(avatar['increments'])
      assert_equal [], rags
    ensure
      avatar_delete id, lion
    end
  end

end
