require_relative 'renamer'

class Updater

  def self.updated(manifest)
    if manifest['language']
      change_1_removed_language(manifest)
    end
    if manifest['runner_choice'].nil?
      change_2_added_runner_choice(manifest)
    end
    # remove dead properties
    manifest.delete('browser')
    manifest.delete('red_amber_green')
    manifest
  end

  private

  def self.change_1_removed_language(manifest)
    # removed manifest['unit_test_framework'] property
    # removed manifest['language] property
    # These coupled a manifest to a start-point
    # Better for the manifest to be self-contained
    display_name = language_2_display_name(manifest['language'])
    # add new properties
    manifest['display_name'] = display_name
    manifest['image_name'] = cache(display_name)['image_name']
    # remove old properties
    manifest.delete('language')
    manifest.delete('unit_test_framework')
  end

  def self.language_2_display_name(language)
    parts = language.split('-', 2).map(&:strip)
    Renamer.renamed(parts).join(', ')
  end

  # - - - - - - - - - - - - - - - - -

  def self.change_2_added_runner_choice(manifest)
    # added manifest['runner_choice'] property
    display_name = manifest['display_name']
    manifest['runner_choice'] = cache(display_name)['runner_choice']
  end

  # - - - - - - - - - - - - - - - - -

  def self.cache(display_name)
    CACHE[display_name]
  end

  # - - - - - - - - - - - - - - - - -

  CACHE =
  {
    "Asm, assert" => {
      "image_name" => "cyberdojofoundation/nasm_assert",
      "runner_choice" => "stateless"
    },

    "Bash, bats" => {
      "image_name" => "cyberdojofoundation/bash_bats",
      "runner_choice" => "stateless"
    },
    "Bash, shunit2" => {
      "image_name" => "cyberdojofoundation/bash_shunit2",
      "runner_choice" => "stateless"
    },
    "Bash, bash_unit" => {
      "image_name" => "cyberdojofoundation/bash_unit",
      "runner_choice" => "stateless"
    },

    "BCPL, all_tests_passed" => {
      "image_name" => "cyberdojofoundation/bcpl_all_tests_passed",
      "runner_choice" => "stateless"
    },

    "C (clang), Cgreen" => {
      "image_name" => "cyberdojofoundation/clang_cgreen",
      "runner_choice" => "stateless"
    },
    "C (clang), assert" => {
      "image_name" => "cyberdojofoundation/clang_assert",
      "runner_choice" => "stateless"
    },

    "C (gcc), Cgreen" => {
      "image_name" => "cyberdojofoundation/gcc_cgreen",
      "runner_choice" => "stateless"
    },
    "C (gcc), CppUTest" => {
      "image_name" => "cyberdojofoundation/gcc_cpputest",
      "runner_choice" => "stateful"
    },
    "C (gcc), GoogleTest" => {
      "image_name" => "cyberdojofoundation/gcc_googletest",
      "runner_choice" => "stateless"
    },
    "C (gcc), assert" => {
      "image_name" => "cyberdojofoundation/gcc_assert",
      "runner_choice" => "stateless"
    },

    "C#, Moq" => {
      "image_name" => "cyberdojofoundation/csharp_moq",
      "runner_choice" => "stateless"
    },
    "C#, NUnit" => {
      "image_name" => "cyberdojofoundation/csharp_nunit",
      "runner_choice" => "stateless"
    },
    "C#, SpecFlow" => {
      "image_name" => "cyberdojofoundation/csharp_specflow",
      "runner_choice" => "stateless"
    },


    "C++ (clang++), Cgreen" => {
      "image_name" => "cyberdojofoundation/clangpp_cgreen",
      "runner_choice" => "stateless"
    },
    "C++ (clang++), GoogleMock" => {
      "image_name" => "cyberdojofoundation/clangpp_googlemock",
      "runner_choice" => "stateless"
    },
    "C++ (clang++), GoogleTest" => {
      "image_name" => "cyberdojofoundation/clangpp_googletest",
      "runner_choice" => "stateless"
    },
    "C++ (clang++), Igloo" => {
      "image_name" => "cyberdojofoundation/clangpp_igloo",
      "runner_choice" => "stateless"
    },
    "C++ (clang++), assert" => {
      "image_name" => "cyberdojofoundation/clangpp_assert",
      "runner_choice" => "stateless"
    },

    "C++ (g++), Boost.Test" => {
      "image_name" => "cyberdojofoundation/gpp_boosttest",
      "runner_choice" => "stateless"
    },
    "C++ (g++), Catch" => {
      "image_name" => "cyberdojofoundation/gpp_catch",
      "runner_choice" => "stateful"
    },
    "C++ (g++), Cgreen" => {
      "image_name" => "cyberdojofoundation/gpp_cgreen",
      "runner_choice" => "stateless"
    },
    "C++ (g++), CppUTest" => {
      "image_name" => "cyberdojofoundation/gpp_cpputest",
      "runner_choice" => "stateful"
    },
    "C++ (g++), GoogleMock" => {
      "image_name" => "cyberdojofoundation/gpp_googlemock",
      "runner_choice" => "stateless"
    },
    "C++ (g++), GoogleTest" => {
      "image_name" => "cyberdojofoundation/gpp_googletest",
      "runner_choice" => "stateless"
    },
    "C++ (g++), Igloo" => {
      "image_name" => "cyberdojofoundation/gpp_igloo",
      "runner_choice" => "stateless"
    },
    "C++ (g++), assert" => {
      "image_name" => "cyberdojofoundation/gpp_assert",
      "runner_choice" => "stateless"
    },

    "Chapel, assert" => {
      "image_name" => "cyberdojofoundation/chapel_assert",
      "runner_choice" => "stateless"
    },

    "Clojure, Midje" => {
      "image_name" => "cyberdojofoundation/clojure_midje",
      "runner_choice" => "stateless"
    },
    "Clojure, clojure.test" => {
      "image_name" => "cyberdojofoundation/clojure_clojure_test",
      "runner_choice" => "stateless"
    },

    "CoffeeScript, jasmine" => {
      "image_name" => "cyberdojofoundation/coffeescript_jasmine",
      "runner_choice" => "stateless"
    },

    "D, unittest" => {
      "image_name" => "cyberdojofoundation/d_unittest",
      "runner_choice" => "stateless"
    },

    "Elixir, ExUnit" => {
      "image_name" => "cyberdojofoundation/elixir_exunit",
      "runner_choice" => "stateless"
    },

    "Erlang, eunit" => {
      "image_name" => "cyberdojofoundation/erlang_eunit",
      "runner_choice" => "stateless"
    },

    "F#, NUnit" => {
      "image_name" => "cyberdojofoundation/fsharp_nunit",
      "runner_choice" => "stateless"
    },

    "Fortran, FUnit" => {
      "image_name" => "cyberdojofoundation/fortran_funit",
      "runner_choice" => "stateless"
    },

    "Go, testing" => {
      "image_name" => "cyberdojofoundation/go_testing",
      "runner_choice" => "stateless"
    },

    "Groovy, JUnit" => {
      "image_name" => "cyberdojofoundation/groovy_junit",
      "runner_choice" => "stateless"
    },
    "Groovy, Spock" => {
      "image_name" => "cyberdojofoundation/groovy_spock",
      "runner_choice" => "stateless"
    },

    "Haskell, hunit" => {
      "image_name" => "cyberdojofoundation/haskell_hunit",
      "runner_choice" => "stateless"
    },

    "Java, Cucumber" => {
      "image_name" => "cyberdojofoundation/java_cucumber_pico",
      "runner_choice" => "stateless"
    },
    "Java, Cucumber-Spring" => {
      "image_name" => "cyberdojofoundation/java_cucumber_spring",
      "runner_choice" => "stateless"
    },
    "Java, JMock" => {
      "image_name" => "cyberdojofoundation/java_jmock",
      "runner_choice" => "stateless"
    },
    "Java, JUnit" => {
      "image_name" => "cyberdojofoundation/java_junit",
      "runner_choice" => "stateless"
    },
    "Java, JUnit-Sqlite" => {
      "image_name" => "cyberdojofoundation/java_junit_sqlite",
      "runner_choice" => "stateful"
    },
    "Java, Mockito" => {
      "image_name" => "cyberdojofoundation/java_mockito",
      "runner_choice" => "stateless"
    },
    "Java, PowerMockito" => {
      "image_name" => "cyberdojofoundation/java_powermockito",
      "runner_choice" => "stateless"
    },


    "Javascript, Cucumber" => {
      "image_name" => "cyberdojofoundation/javascript-node_cucumber",
      "runner_choice" => "stateless"
    },
    "Javascript, Mocha+chai+sinon" => {
      "image_name" => "cyberdojofoundation/javascript-node_mocha_chai_sinon",
      "runner_choice" => "stateless"
    },
    "Javascript, assert" => {
      "image_name" => "cyberdojofoundation/javascript-node_assert",
      "runner_choice" => "stateless"
    },
    "Javascript, assert+jQuery" => {
      "image_name" => "cyberdojofoundation/javascript-node_assert-jquery",
      "runner_choice" => "stateless"
    },
    "Javascript, jasmine" => {
      "image_name" => "cyberdojofoundation/javascript-node_jasmine",
      "runner_choice" => "stateless"
    },
    "Javascript, qunit+sinon" => {
      "image_name" => "cyberdojofoundation/javascript-node_qunit_sinon",
      "runner_choice" => "stateless"
    },

    "Kotlin, Kotlintest" => {
      "image_name" => "cyberdojofoundation/kotlin_kotlintest",
      "runner_choice" => "stateless"
    },

    "PHP, PHPUnit" => {
      "image_name" => "cyberdojofoundation/php_phpunit",
      "runner_choice" => "stateless"
    },

    "Perl, Test::Simple" => {
      "image_name" => "cyberdojofoundation/perl_test_simple",
      "runner_choice" => "stateless"
    },

    "Python, behave" => {
      "image_name" => "cyberdojofoundation/python_behave",
      "runner_choice" => "stateless"
    },
    "Python, py.test" => {
      "image_name" => "cyberdojofoundation/python_pytest",
      "runner_choice" => "stateless"
    },
    "Python, unittest" => {
      "image_name" => "cyberdojofoundation/python_unittest",
      "runner_choice" => "stateless"
    },

    "R, RUnit" => {
      "image_name" => "cyberdojofoundation/r_runit",
      "runner_choice" => "stateless"
    },

    "Ruby, Cucumber" => {
      "image_name" => "cyberdojofoundation/ruby_cucumber",
      "runner_choice" => "stateless"
    },
    "Ruby, MiniTest" => {
      "image_name" => "cyberdojofoundation/ruby_mini_test",
      "runner_choice" => "stateless"
    },
    "Ruby, RSpec" => {
      "image_name" => "cyberdojofoundation/ruby_rspec",
      "runner_choice" => "stateless"
    },
    "Ruby, Test::Unit" => {
      "image_name" => "cyberdojofoundation/ruby_test_unit_sinatra",
      "runner_choice" => "processful"
    },

    "Rust, test" => {
      "image_name" => "cyberdojofoundation/rust_test",
      "runner_choice" => "stateless"
    },

    "Swift, Swordfish" => {
      "image_name" => "cyberdojofoundation/swift_swordfish",
      "runner_choice" => "stateless"
    },
    "Swift, XCTest" => {
      "image_name" => "cyberdojofoundation/swift_xctest",
      "runner_choice" => "stateful"
    },

    "VHDL, assert" => {
      "image_name" => "cyberdojofoundation/vhdl_assert",
      "runner_choice" => "stateless"
    },

    "VisualBasic, NUnit" => {
      "image_name" => "cyberdojofoundation/visual-basic_nunit",
      "runner_choice" => "stateless"
    }
  }

end
