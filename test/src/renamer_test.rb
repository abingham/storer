require_relative 'test_base'
require_relative '../../src/renamer'

class RenamerTest < TestBase

  def self.hex_prefix
    '1BF95'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C3', %w( when not-found and known return arg ) do
    assert_renamed ['Ruby','Test::Unit'], ['Ruby','Test::Unit']
    assert_renamed ['Javascript','Mocha+chai+sinon'], ['Javascript','Mocha+chai+sinon']
    assert_renamed ['Perl','Test::Simple'],['Perl','Test::Simple']
    assert_renamed ['Python','py.test'],['Python','py.test']
    assert_renamed ['Ruby','RSpec'],['Ruby','RSpec']
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C4', %w( when not-found and unknown return arg ) do
    assert_not_renamed ['x']
    assert_not_renamed ['C','x']
    assert_not_renamed ['x','TestSimple']
    assert_not_renamed ['x','Test::Simple']
    assert_not_renamed ['x','y','z']
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C5', %w( when test-name was not part of language-name and had no hyphen ) do
    assert_renamed ['BCPL'], ['BCPL','all_tests_passed']
    assert_renamed ['C'], ['C (gcc)','assert']
    assert_renamed ['C++'], ['C++ (g++)','assert']
    assert_renamed ['C#'], ['C#','NUnit']
    assert_renamed ['CoffeeScript'], ['CoffeeScript','jasmine']
    assert_renamed ['Erlang'], ['Erlang','eunit']
    assert_renamed ['Go'], ['Go','testing']
    assert_renamed ['Haskell'], ['Haskell','hunit']
    assert_renamed ['Java'], ['Java','JUnit']
    assert_renamed ['Javascript'], ['Javascript','assert']
    assert_renamed ['Perl'], ['Perl','Test::Simple']
    assert_renamed ['PHP'], ['PHP','PHPUnit']
    assert_renamed ['Python'], ['Python','unittest']
    assert_renamed ['Ruby'], ['Ruby','Test::Unit']
    assert_renamed ['Scala'], ['Scala','scalatest']
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test '9C6', %w( renamed to distinguish between gcc and clang ) do
    assert_renamed ['C','assert'  ], ['C (gcc)','assert']
    assert_renamed ['C','Unity'   ], ['C (gcc)','Unity']
    assert_renamed ['C','CppUTest'], ['C (gcc)','CppUTest']
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C7', %w( renamed to distinguish between g++ and clang++ ) do
    assert_renamed ['C++','assert'    ], ['C++ (g++)','assert']
    assert_renamed ['C++','Boost.Test'], ['C++ (g++)','Boost.Test']
    assert_renamed ['C++','Catch'     ], ['C++ (g++)','Catch']
    assert_renamed ['C++','CppUTest'  ], ['C++ (g++)','CppUTest']
    assert_renamed ['C++','GoogleTest'], ['C++ (g++)','GoogleTest']
    assert_renamed ['C++','GoogleMock'], ['C++ (g++)','GoogleMock']
    assert_renamed ['C++','Igloo'     ], ['C++ (g++)','Igloo']
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C8', %w( renamed to remove version number ) do
    assert_renamed ['Java','1.8_Approval'],     ['Java','Approval']
    assert_renamed ['Java','1.8_Cucumber'],     ['Java','Cucumber']
    assert_renamed ['Java','1.8_JMock'],        ['Java','JMock']
    assert_renamed ['Java','1.8_JUnit'],        ['Java','JUnit']
    assert_renamed ['Java','1.8_Mockito'],      ['Java','Mockito']
    assert_renamed ['Java','1.8_Powermockito'], ['Java','PowerMockito']
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C9', %w( renamed ) do
    assert_renamed ['C++','catch'], ['C++ (g++)','Catch'] # capital S
    assert_renamed ['Java','ApprovalTests'],   ['Java','Approval']
    assert_renamed ['Java','JUnit','Mockito'], ['Java','Mockito']
    assert_renamed ['Perl','TestSimple'], ['Perl','Test::Simple']
    assert_renamed ['Ruby','Rspec'], ['Ruby','RSpec'] # capital S
    assert_renamed ['Ruby','TestUnit'], ['Ruby','Test::Unit']
    assert_renamed ['R','stopifnot'], ['R','RUnit']
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_renamed(from, to)
    assert_equal to, Renamer.renamed(from)
  end

  def assert_not_renamed(arg)
    assert_equal arg, Renamer.renamed(arg)
  end

end

=begin
# from web
class LanguagesTest < AppModelsTestBase

  def historical_language_names
    # these names harvested from cyber-dojo.org
    # from dirs katas/../......../manifest.json { language: X }
    # Also listed are count of occurences on cyber-dojo.org
    # and ID of one occurrence on cyber-dojo.org
    [
      'Asm-assert 25 010E66019D',
      'BCPL 3 DF9A083C0F',
      'BCPL-all_tests_passed 18 C411C2351E',
      'C 479 54529AA3BE',
      'C# 1473 54F993C99A',
      'C#-NUnit 3088 54009537D3',
      'C#-SpecFlow 229 543E10EB15',
      'C++ 535 54E041DECA',
      'C++-Boost.Test 55 54C6A3B75B',
      'C++-Catch 352 54652F82AD',
      'C++-CppUTest 662 54A93BB04C',
      'C++-GoogleMock 19 280B752660',
      'C++-GoogleTest 1452 54C157173A',
      'C++-Igloo 46 280DB28223',
      'C++-assert 1015 545111471C',
      'C-Unity 450 5498403AF6',
      'C-assert 836 54B99F4CE2',
      #'Clojure 67 5A53D42987',          # offline
      #'Clojure-.test 177 546B4184B4',   # offline
      'CoffeeScript 47 014F4190E0',
      'CoffeeScript-jasmine 83 54219ECA71',
      'D-unittest 45 541349CE61',
      'Erlang 45 282F687601',
      'Erlang-eunit 121 543F979F1C',
      'F#-NUnit 101 5447BFDCB0',
      'Fortran-FUnit 64 016105DBCD',
      'Go 47 AA393DDF4B',
      'Go-testing 155 2849773A9C',
      'Groovy-JUnit 117 5A776302BC',
      'Groovy-Spock 109 AADE304AC9',
      'Haskell 81 23939E0066',
      'Haskell-hunit 146 28894CFFC1',
      'Java 17 23A7CF3454',
      'Java-1.8_Approval 389 54D58851FE',
      'Java-1.8_Cucumber 228 54303D90C6',
      'Java-1.8_JMock 43 C484782160',
      'Java-1.8_JUnit 3648 5437D7B510',
      'Java-1.8_Mockito 313 540E06E467',
      'Java-1.8_Powermockito 56 339F6FF85A',
      'Java-Approval 220 54624C174C',
      'Java-Cucumber 163 543D714DF5',
      'Java-JUnit 1708 54FB5612C3',
      'Java-JUnit-Mockito 160 54359DB8B5',
      'Java-Mockito 37 020B8A969E',
      'Java-PowerMockito 6 D360343B60',
      'Javascript 474 54210DA681',
      'Javascript-assert 517 549D533F36',
      'Javascript-jasmine 534 5A749EFF33',
      'Javascript-mocha_chai_sinon 128 5A405D8EE2',
      'PHP 396 54C77C53AA',
      'PHP-PHPUnit 827 541E1B649B',
      'Perl 57 549C58C8BA',
      'Perl-TestSimple 112 287BE6DEDB',
      'Python 621 54F07B407C',
      'Python-pytest 815 5496730F04',
      'Python-unittest 1242 548F3E67A7',
      'R-RUnit 37 54811DAFB1',
      'R-stopifnot 2 F0A5407B87',
      'Ruby 339 54EE119F79',
      'Ruby-Approval 149 283E57E66D', # offline
      'Ruby-Cucumber 154 28A62BD7AA',
      'Ruby-Rspec 508 545144CA06',
      'Ruby-TestUnit 412 546A3CCA40',
      'Scala-scalatest 190 5A3EE246D6'
    ].each do |entry|
      yield entry.split[0]
    end
  end

end

=end
