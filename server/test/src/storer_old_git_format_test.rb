require_relative 'test_base'
require_relative 'spy_logger'
require_relative '../../src/all_avatars_names'

class StorerOldGitFormatTest < TestBase

  def self.hex_prefix
    'BBDB3'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'C33',
  'katas/5A/0F824303/spider already exists and is in old git format' do
    assert disk["#{cyber_dojo_katas_root}/5A/0F824303/spider/.git"].exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'D21',
  'old git-format increments can be retrieved' do
    kata_id = '5A0F824303'
    rags = storer.avatar_increments(kata_id, spider)
    assert 8, rags.size
    tag0 = {
      'event'  => 'created',
      'time'   => [ 2016, 11, 23, 8, 34, 28 ],
      'number' => 0
    }
    assert_hash_equal tag0, rags[0]
    tag1 = {
      'colour'  => 'red',
      'time'    => [ 2016, 11, 23, 8, 34, 33 ],
      'number'  => 1
    }
    assert_hash_equal tag1, rags[1]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '694',
  'old git-format tag-zero visible-files can be retrieved' do
    kata_id = '5A0F824303'
    files = storer.tag_visible_files(kata_id, spider, tag=0)
    expected_filenames = [
      'cyber-dojo.sh',
      'instructions',
      'README',
      'hiker.feature',
      'hiker.py',
      'hiker_steps.py',
      'output'
    ]
    assert_equal expected_filenames.sort, files.keys.sort
    expected = [
      '',
      'class Hiker:',
      '',
      '    def answer(self, first, second):',
      '        return first * second',
      ''
    ].join("\n")
    assert_equal expected, files['hiker.py']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '765',
  'old git-format tag-non-zero visible-files can be retrieved' do
    kata_id = '5A0F824303'
    files1 = storer.tag_visible_files(kata_id, spider, tag=1)
    expected_filenames = [
      'cyber-dojo.sh',
      'instructions',
      'README',
      'hiker.feature',
      'hiker.py',
      'hiker_steps.py',
      'output'
    ]
    assert_equal expected_filenames.sort, files1.keys.sort
    expected1 = [
      '',
      'Feature: hitch-hiker playing scrabble',
      '',
      'Scenario: last earthling playing scrabble in the past',
      'Given the hitch-hiker selects some tiles',
      'When they spell 6 times 9', # <-----
      'Then the score is 42',
      ''
    ].join("\n")
    assert_equal expected1, files1['hiker.feature']

    files2 = storer.tag_visible_files(kata_id, spider, tag=2)
    assert_equal expected_filenames.sort, files2.keys.sort
    expected2 = [
      '',
      'Feature: hitch-hiker playing scrabble',
      '',
      'Scenario: last earthling playing scrabble in the past',
      'Given the hitch-hiker selects some tiles',
      'When they spell 6 times 7', # <-----
      'Then the score is 42',
      ''
    ].join("\n")
    assert_equal expected2, files2['hiker.feature']
  end

  private

  def spider
    'spider'
  end

end
