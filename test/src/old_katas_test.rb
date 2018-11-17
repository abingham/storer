require_relative 'test_base'

class OldKatasTest < TestBase

  def self.hex_prefix
    '9B191'
  end

  # - - - - - - - - - - - - - - - -

  test '0D4',
  'katas that were missing an Updater.cache(display_name) entry' do
    kata_ids = [
      ['7E010BE86C', 'Java, JUnit-Mockito'],
      ['7E2AEE8E64', 'Java, JUnit-Mockito'],
      ['7E9B1F7E60', 'Scala, scalatest'],
      ['7E218AC28C', 'Scala, scalatest'],
      ['7E6DEF1D86', 'Scala, scalatest'],
      ['7EA354ED66', 'Ruby, Approval'],
      ['7EC98B56F7', 'Java, JUnit-Mockito'],
      ['7EA0979D3E', 'Java, Approval'],
    ]
    kata_ids.each do |e|
      kata_id = e[0]
      display_name = e[1]
      manifest = kata_manifest(kata_id)
      assert_equal display_name, manifest['display_name'], kata_id
    end
  end

  # - - - - - - - - - - - - - - - -

  test '0D5',
  'katas that also have no entry in the Updater.cache' do
    # ['7E246F2339', 'C (gcc), Unity']  --> No entry in cache
    # ['7E12E5A294', 'C (gcc), Unity']
    # ['7E53732F00', 'Clojure, .test']
    # ['7EC7A19DF3', 'Java Countdown, Round 1']
  end

end
