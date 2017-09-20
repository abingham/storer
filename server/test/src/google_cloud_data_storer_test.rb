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

  def write(filename, content)
    #@bucket.create_file(StringIO.new(content), filename)
  end

  def read(filename)
    #@bucket.file(filename).download.string
  end

  def exists?(filename)
    #@bucket.file(filename) != nil
  end

  def delete(filename)
    #@bucket.file(filename).delete
  end

  def files(prefix)
    #@bucket.files({ :prefix => prefix })
  end

  private

end

class GoogleCloudDataStorerTest < TestBase

  def self.hex_prefix; '2B1E8DF'; end

  def storer
    GoogleCloudDataStorerSpike.new
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '02D',
  'datastore creation' do
    storer
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

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

  test '025',
  'start a kata' do
    s = storer
    kata = nil
    #kata_id = '345345345'  #1
    #kata_id = 'AB53E04534' #2
    kata_id = '9993E04534'

    kata = s.datastore.entity 'kata', kata_id do |k|
      k['manifest'] = '{...json....here....}'
    end

    s.datastore.transaction do |tx|
      if tx.find(kata.key).nil?
        r = tx.save kata
        puts "created new kata"
        puts r.class.name
        puts r
      else
        puts "!kata.nil? --> kata already exists"
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test '021',
  'find data based on content' do
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

  test '022',
  'deleting data' do

  end

=begin
  test '838',
  'write-read round-trip' do
    filename = 'nuts.txt'
    content = 'cashew'
    storer.write(filename, content)
    assert_equal content, storer.read(filename)
  end

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
