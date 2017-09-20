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
  # ...refactored up to here...
  # - - - - - - - - - - - - - - - - - - - - - - -

  test '030',
  'read based on key' do
    id = '65CFFFEC38'
    key = datastore.key [['kata', id], ['avatar', 'lion']]
    avatar = datastore.find key
    rags = JSON.parse(avatar['increments'])
    assert_equal 'Array', rags.class.name
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '031',
  'atomically update an avatars increments' do
    id = 'B7FAA22CCB'
    key = datastore.key [['kata', id], ['avatar', 'lion']]
    datastore.transaction do |tx|
      avatar = tx.find key
      rags = JSON.parse(avatar['increments'])
      rags << 'red'
      avatar['increments'] = JSON.unparse(rags)
      datastore.save avatar
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '02A',
  'completing a 6-digit kata-id to 10-digits' do
    id = '4B80741C3C'
    kata_start id
    begin
      key_prefix = id[0..5]
      query = datastore.query('kata').where('key_prefix','=',key_prefix)
      all = datastore.run query
      assert_equal 1, all.size
      assert_equal id, all.to_a[0].key.name
    ensure
      kata_delete id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

=begin

  test '020',
  'writing data - example from google.cloud web-page' do
    task = storer.datastore.entity 'Task' do |t|
      t['description'] = 'hello world'
      t['created']     = Time.now
      t['done']        = false
      t.exclude_from_indexes! 'description', true
    end
    storer.datastore.save task
    assert_equal 'Fixnum', task.key.id.class.name
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '021',
  'read based on content' do
    e = storer.datastore.entity 'traffic-light' do |rag|
      rag['id1'] = '93'
      rag['id2'] = '63EF'
      rag['id3'] = '9A5E'
      rag['colour'] = 'red'
      rag.exclude_from_indexes! 'colour', true
    end
    storer.datastore.save e

    query = storer.datastore.query('traffic-light').
              where('id1','==','93').
              where('id2','==','63EF').
              where('id3','==','9A5E')

    rags = storer.datastore.run query
    rags.each do |rag|
      puts "~~~~~"
      puts rag.properties.to_hash
      puts "~~~~~"
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '838',
  'write-read round-trip' do
    filename = 'nuts.txt'
    content = 'cashew'
    storer.write(filename, content)
    assert_equal content, storer.read(filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '839',
  'write overwrites previous write' do
    filename = 'nuts.txt'
    storer.write(filename, content='cashew')
    begin
      assert_equal content, storer.read(filename)
      storer.write(filename, content='brazil')
      assert_equal content, storer.read(filename)
    ensure
      storer.delete filename
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '83A',
  'exists?(existing-file) is true' do
    filename = 'nuts.txt'
    storer.write(filename, content='cashew')
    begin
      assert storer.exists? filename
    ensure
      storer.delete filename
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '83B',
  'exists?(non-existant-file) is false' do
    refute storer.exists? 'does-not-exist.txt'
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '83C',
  'delete(existing-file) succeeds and file no longer exists' do
    filename = 'nuts.txt'
    storer.write(filename, content='cashew')
    storer.delete(filename)
    refute storer.exists? filename
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '83D',
  'delete(never-existed-file) raises' do
    filename = '123456321245.txt'
    assert_raises { storer.delete(filename) }
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '9ED',
  'files one simple completion' do
    filename = 'nuts.txt'
    storer.write(filename, content='cashew')
    begin
      files = storer.files('nu')
      all = files.collect { |file| file.name }
      assert_equal [ 'nuts.txt' ], all
    ensure
      storer.delete filename
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test '9EE',
  'files more than one simple completion' do
    filename1 = 'fruit.txt'
    filename2 = 'fruit2.txt'
    storer.write(filename1, 'bananas')
    storer.write(filename2, 'apples')
    begin
      files = storer.files('fru')
      all = files.collect { |file| file.name }
      assert_equal [ filename1, filename2 ].sort, all.sort
    ensure
      storer.delete filename1
      storer.delete filename2
    end
  end

  test '9EF',
  'files more than one not-so-simple completion' do
    filename1 = '19/23456789/fruit.txt'
    filename2 = '19/23456789/fruit2.txt'
    filename3 = '91/23456789/nuts6.txt'
    storer.write(filename1, 'bananas')
    storer.write(filename2, 'apples')
    storer.write(filename3, 'peanut')
    begin
      files = storer.files('19/23456789')
      all = files.collect { |file| file.name }
      assert_equal [ filename1, filename2 ].sort, all.sort
    ensure
      storer.delete filename1
      storer.delete filename2
      storer.delete filename3
    end
  end
=end

end
