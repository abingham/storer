require_relative 'storer_test_base'

class ExternalGitterTest < StorerTestBase

  def self.hex_prefix; 'C89'; end

  test '65D',
  'retrieval of visible-files in known old-git-format kata' do
    path = storer.path + '/5A/0F824303/spider'
    tag = 1
    filename = 'hiker.py'
    src = git.show(path, "#{tag}:sandbox/#{filename}")
    refute_nil src
    assert src.include? 'class Hiker:'
    assert src.include?   'def answer(self, first, second):'
    assert src.include?     'return first * second'
  end

end
