
class Renamer

  def self.renamed(parts)
    RENAMED[parts] || parts
  end

  private

  RENAMED = {
    # from way back when test name was _not_ part of language name
    ['BCPL']         => ['BCPL',         'all_tests_passed'],
    ['C']            => ['C (gcc)',      'assert'],
    ['C++']          => ['C++ (g++)',    'assert'],
    ['C#']           => ['C#',           'NUnit'],
    ['Clojure']      => ['Clojure',      'clojure.test'],
    ['CoffeeScript'] => ['CoffeeScript', 'jasmine'],
    ['Erlang']       => ['Erlang',       'eunit'],
    ['Go']           => ['Go',           'testing'],
    ['Haskell']      => ['Haskell',      'hunit'],
    ['Java']         => ['Java',         'JUnit'],
    ['Javascript']   => ['Javascript',   'assert'],
    ['Perl']         => ['Perl',         'Test::Simple'],
    ['PHP']          => ['PHP',          'PHPUnit'],
    ['Python']       => ['Python',       'unittest'],
    ['Ruby']         => ['Ruby',         'Test::Unit'],
    ['Scala']        => ['Scala',        'scalatest'],
    # renamed
    ['Clojure', '.test'] => ['Clojure', 'clojure.test'],
    ['C++', 'catch'         ] => ['C++ (g++)' , 'Catch'],
    ['Java', 'ApprovalTests'] => ['Java', 'Approval'], # offline
    ['Java',       'JUnit','Mockito']  => ['Java',       'Mockito'],
    ['Javascript', 'mocha_chai_sinon'] => ['Javascript', 'Mocha+chai+sinon'],
    ['Perl',       'TestSimple']       => ['Perl',       'Test::Simple'],
    ['Ruby',       'Rspec']            => ['Ruby',       'RSpec'], # capital S
    ['Ruby',       'TestUnit']         => ['Ruby',       'Test::Unit'],
    ['Python',     'pytest']           => ['Python',     'py.test'], # dot
    # - in the wrong place
    ['Java', '1.8_Approval']     => ['Java', 'Approval'],  # offline
    ['Java', '1.8_Cucumber']     => ['Java', 'Cucumber'],
    ['Java', '1.8_JMock']        => ['Java', 'JMock'],
    ['Java', '1.8_JUnit']        => ['Java', 'JUnit'],
    ['Java', '1.8_Mockito']      => ['Java', 'Mockito'],
    ['Java', '1.8_Powermockito'] => ['Java', 'PowerMockito'],
    # replaced
    ['R', 'stopifnot'] => ['R', 'RUnit'],
    # renamed to distinguish from [C (clang)]
    ['C', 'assert']   => ['C (gcc)', 'assert'],
    ['C', 'Unity']    => ['C (gcc)', 'Unity'],
    ['C', 'CppUTest'] => ['C (gcc)', 'CppUTest'],
    # renamed to distinguish from [C++ (clang++)]
    ['C++', 'assert']     => ['C++ (g++)', 'assert'],
    ['C++', 'Boost.Test'] => ['C++ (g++)', 'Boost.Test'],
    ['C++', 'Catch']      => ['C++ (g++)', 'Catch'],
    ['C++', 'CppUTest']   => ['C++ (g++)', 'CppUTest'],
    ['C++', 'GoogleTest'] => ['C++ (g++)', 'GoogleTest'],
    ['C++', 'Igloo']      => ['C++ (g++)', 'Igloo'],
    ['C++', 'GoogleMock'] => ['C++ (g++)', 'GoogleMock'],
  }

end
