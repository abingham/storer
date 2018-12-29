require_relative 'renamer'

class Updater

  def self.updated(manifest)
    change_1_decouple_from_start_points(manifest)
    change_2_added_runner_choice(manifest)
    change_3_required_filename_extension(manifest)
    fixup_bad_data(manifest)
    delete_dead_properties(manifest)
    manifest
  end

  private

  def self.change_1_decouple_from_start_points(manifest)
    unless manifest['language']
      return
    end
    # Don't use 'unit_test_framework' or 'language'
    # properties - as these coupled a manifest to a start-point.
    # Better for the manifest to be self-contained, so
    # embed image_name in the manifest.
    display_name = language_to_display_name(manifest['language'])
    # add new properties
    manifest['display_name'] = display_name
    manifest['image_name'] ||= cache(display_name)['image_name']
  end

  # - - - - - - - - - - - - - - - - -

  def self.language_to_display_name(language)
    parts = language.split('-', 2).map(&:strip)
    Renamer.renamed(parts).join(', ')
  end

  # - - - - - - - - - - - - - - - - -

  def self.change_2_added_runner_choice(manifest)
    # Made 'runner_choice' a required property.
    if manifest['runner_choice']
      return
    end
    display_name = manifest['display_name']
    entry = cache(display_name)
    if entry
      # a non-custom practice-session
      manifest['runner_choice'] = entry['runner_choice']
      return
    end
    # a custom practice-session
    found = CACHE.values.find { |value|
      value['image_name'] == manifest['image_name']
    }
    if found
      manifest['runner_choice'] = found['runner_choice']
    end
  end

  # - - - - - - - - - - - - - - - - -

  def self.change_3_required_filename_extension(manifest)
    # Made filename_extension a required property.
    # Also made it an array for languages like C/C++
    # which have more than one extension.
    fe = manifest['filename_extension']
    if fe.is_a?(Array)
      return
    end
    if fe.is_a?(String)
      manifest['filename_extension'] = [ fe ]
      return
    end
    display_name = manifest['display_name']
    fe = cache(display_name)['filename_extension']
    if fe.is_a?(String)
      fe = [ fe ]
    end
    manifest['filename_extension'] = fe
  end

  # - - - - - - - - - - - - - - - - -

  def self.fixup_bad_data(manifest)
    if manifest['exercise'].nil?
      manifest.delete('exercise')
    end
  end

  # - - - - - - - - - - - - - - - - -

  def self.delete_dead_properties(manifest)
    names = %w(
      language
      name
      unit_test_framework
      lowlight_filenames
      browser
      red_amber_green
      diff_id
      diff_language
      diff_exercise
      diff_avatar
      diff_tag
    )
    names.each do |name|
      manifest.delete(name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  def self.cache(display_name)
    CACHE[display_name]
  end

  # - - - - - - - - - - - - - - - - -

  CACHE = {
    "git, bash" => {
      "image_name" => "cyberdojofoundation/bash_bats",
      "runner_choice" => "stateless",
      "filename_extension" => ".sh"
    },

    "Asm, assert" => {
      "image_name" => "cyberdojofoundation/nasm_assert",
      "runner_choice" => "stateless",
      "filename_extension" => ".asm"
    },

    "Bash, bats" => {
      "image_name" => "cyberdojofoundation/bash_bats",
      "runner_choice" => "stateless",
      "filename_extension" => ".sh"
    },
    "Bash, shunit2" => {
      "image_name" => "cyberdojofoundation/bash_shunit2",
      "runner_choice" => "stateless",
      "filename_extension" => ".sh"
    },
    "Bash, bash_unit" => {
      "image_name" => "cyberdojofoundation/bash_unit",
      "runner_choice" => "stateless",
      "filename_extension" => ".sh"
    },

    "BCPL, all_tests_passed" => {
      "image_name" => "cyberdojofoundation/bcpl_all_tests_passed",
      "runner_choice" => "stateless",
      "filename_extension" => ".b"
    },

    "C (clang), Cgreen" => {
      "image_name" => "cyberdojofoundation/clang_cgreen",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },
    "C (clang), assert" => {
      "image_name" => "cyberdojofoundation/clang_assert",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },

    "C (gcc), Cgreen" => {
      "image_name" => "cyberdojofoundation/gcc_cgreen",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },
    "C (gcc), CppUTest" => {
      "image_name" => "cyberdojofoundation/gcc_cpputest",
      "runner_choice" => "stateful",
      "filename_extension" => [ ".c", ".h" ]
    },
    "C (gcc), GoogleTest" => {
      "image_name" => "cyberdojofoundation/gcc_googletest",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },
    "C (gcc), assert" => {
      "image_name" => "cyberdojofoundation/gcc_assert",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },
    "C (gcc), Unity" => {
      "image_name" => "cyberdojofoundation/gcc_unity",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".c", ".h" ]
    },

    "C#, Moq" => {
      "image_name" => "cyberdojofoundation/csharp_moq",
      "runner_choice" => "stateless",
      "filename_extension" => ".cs"
    },
    "C#, NUnit" => {
      "image_name" => "cyberdojofoundation/csharp_nunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".cs"
    },
    "C#, SpecFlow" => {
      "image_name" => "cyberdojofoundation/csharp_specflow",
      "runner_choice" => "stateless",
      "filename_extension" => ".cs"
    },


    "C++ (clang++), Cgreen" => {
      "image_name" => "cyberdojofoundation/clangpp_cgreen",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (clang++), GoogleMock" => {
      "image_name" => "cyberdojofoundation/clangpp_googlemock",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (clang++), GoogleTest" => {
      "image_name" => "cyberdojofoundation/clangpp_googletest",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (clang++), Igloo" => {
      "image_name" => "cyberdojofoundation/clangpp_igloo",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (clang++), assert" => {
      "image_name" => "cyberdojofoundation/clangpp_assert",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },

    "C++ (g++), Boost.Test" => {
      "image_name" => "cyberdojofoundation/gpp_boosttest",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), Catch" => {
      "image_name" => "cyberdojofoundation/gpp_catch",
      "runner_choice" => "stateful",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), Cgreen" => {
      "image_name" => "cyberdojofoundation/gpp_cgreen",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), CppUTest" => {
      "image_name" => "cyberdojofoundation/gpp_cpputest",
      "runner_choice" => "stateful",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), GoogleMock" => {
      "image_name" => "cyberdojofoundation/gpp_googlemock",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), GoogleTest" => {
      "image_name" => "cyberdojofoundation/gpp_googletest",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), Igloo" => {
      "image_name" => "cyberdojofoundation/gpp_igloo",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },
    "C++ (g++), assert" => {
      "image_name" => "cyberdojofoundation/gpp_assert",
      "runner_choice" => "stateless",
      "filename_extension" => [ ".cpp", ".hpp" ]
    },

    "Chapel, assert" => {
      "image_name" => "cyberdojofoundation/chapel_assert",
      "runner_choice" => "stateless",
      "filename_extension" => ".chpl"
    },

    "Clojure, Midje" => {
      "image_name" => "cyberdojofoundation/clojure_midje",
      "runner_choice" => "stateless",
      "filename_extension" => ".clj"
    },
    "Clojure, clojure.test" => {
      "image_name" => "cyberdojofoundation/clojure_clojure_test",
      "runner_choice" => "stateless",
      "filename_extension" => ".clj"
    },

    "CoffeeScript, jasmine" => {
      "image_name" => "cyberdojofoundation/coffeescript_jasmine",
      "runner_choice" => "stateless",
      "filename_extension" => ".coffee"
    },

    "D, unittest" => {
      "image_name" => "cyberdojofoundation/d_unittest",
      "runner_choice" => "stateless",
      "filename_extension" => ".d"
    },

    "Elixir, ExUnit" => {
      "image_name" => "cyberdojofoundation/elixir_exunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".ex"
    },

    "Erlang, eunit" => {
      "image_name" => "cyberdojofoundation/erlang_eunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".erl"
    },

    "F#, NUnit" => {
      "image_name" => "cyberdojofoundation/fsharp_nunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".fs"
    },

    "Fortran, FUnit" => {
      "image_name" => "cyberdojofoundation/fortran_funit",
      "runner_choice" => "stateless",
      "filename_extension" => ".f90"
    },

    "Go, testing" => {
      "image_name" => "cyberdojofoundation/go_testing",
      "runner_choice" => "stateless",
      "filename_extension" => ".go"
    },

    "Groovy, JUnit" => {
      "image_name" => "cyberdojofoundation/groovy_junit",
      "runner_choice" => "stateless",
      "filename_extension" => ".groovy"
    },
    "Groovy, Spock" => {
      "image_name" => "cyberdojofoundation/groovy_spock",
      "runner_choice" => "stateless",
      "filename_extension" => ".groovy"
    },

    "Haskell, hunit" => {
      "image_name" => "cyberdojofoundation/haskell_hunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".hs"
    },

    "Java, Approval" => {
      "image_name" => "cyberdojofoundation/java_approval",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, Cucumber" => {
      "image_name" => "cyberdojofoundation/java_cucumber_pico",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, Cucumber-Spring" => {
      "image_name" => "cyberdojofoundation/java_cucumber_spring",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, JMock" => {
      "image_name" => "cyberdojofoundation/java_jmock",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, JUnit" => {
      "image_name" => "cyberdojofoundation/java_junit",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, JUnit-Sqlite" => {
      "image_name" => "cyberdojofoundation/java_junit_sqlite",
      "runner_choice" => "stateful",
      "filename_extension" => ".java"
    },
    "Java, Mockito" => {
      "image_name" => "cyberdojofoundation/java_mockito",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },
    "Java, PowerMockito" => {
      "image_name" => "cyberdojofoundation/java_powermockito",
      "runner_choice" => "stateless",
      "filename_extension" => ".java"
    },


    "Javascript, Cucumber" => {
      "image_name" => "cyberdojofoundation/javascript-node_cucumber",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },
    "Javascript, Mocha+chai+sinon" => {
      "image_name" => "cyberdojofoundation/javascript-node_mocha_chai_sinon",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },
    "Javascript, assert" => {
      "image_name" => "cyberdojofoundation/javascript-node_assert",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },
    "Javascript, assert+jQuery" => {
      "image_name" => "cyberdojofoundation/javascript-node_assert-jquery",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },
    "Javascript, jasmine" => {
      "image_name" => "cyberdojofoundation/javascript-node_jasmine",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },
    "Javascript, qunit+sinon" => {
      "image_name" => "cyberdojofoundation/javascript-node_qunit_sinon",
      "runner_choice" => "stateless",
      "filename_extension" => ".js"
    },

    "Kotlin, Kotlintest" => {
      "image_name" => "cyberdojofoundation/kotlin_kotlintest",
      "runner_choice" => "stateless",
      "filename_extension" => ".kt"
    },

    "PHP, PHPUnit" => {
      "image_name" => "cyberdojofoundation/php_phpunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".php"
    },

    "Perl, Test::Simple" => {
      "image_name" => "cyberdojofoundation/perl_test_simple",
      "runner_choice" => "stateless",
      "filename_extension" => ".pl"
    },

    "Python, behave" => {
      "image_name" => "cyberdojofoundation/python_behave",
      "runner_choice" => "stateless",
      "filename_extension" => ".py"
    },
    "Python, py.test" => {
      "image_name" => "cyberdojofoundation/python_pytest",
      "runner_choice" => "stateless",
      "filename_extension" => ".py"
    },
    "Python, unittest" => {
      "image_name" => "cyberdojofoundation/python_unittest",
      "runner_choice" => "stateless",
      "filename_extension" => ".py"
    },

    "R, RUnit" => {
      "image_name" => "cyberdojofoundation/r_runit",
      "runner_choice" => "stateless",
      "filename_extension" => ".R"
    },

    "Ruby, Approval" => {
      "image_name" => "cyberdojofoundation/ruby_approval",
      "runner_choice" => "stateless",
      "filename_extension" => ".rb"
    },
    "Ruby, Cucumber" => {
      "image_name" => "cyberdojofoundation/ruby_cucumber",
      "runner_choice" => "stateless",
      "filename_extension" => ".rb"
    },
    "Ruby, MiniTest" => {
      "image_name" => "cyberdojofoundation/ruby_mini_test",
      "runner_choice" => "stateless",
      "filename_extension" => ".rb"
    },
    "Ruby, RSpec" => {
      "image_name" => "cyberdojofoundation/ruby_rspec",
      "runner_choice" => "stateless",
      "filename_extension" => ".rb"
    },
    "Ruby, Test::Unit" => {
      "image_name" => "cyberdojofoundation/ruby_test_unit",
      "runner_choice" => "stateless",
      "filename_extension" => ".rb"
    },

    "Rust, test" => {
      "image_name" => "cyberdojofoundation/rust_test",
      "runner_choice" => "stateless",
      "filename_extension" => ".rs"
    },

    "Scala, scalatest" => {
      "image_name" => "cyberdojofoundation/scala_scalatest",
      "runner_choice" => "stateless",
      "filename_extension" => ".scala"
    },

    "Swift, Swordfish" => {
      "image_name" => "cyberdojofoundation/swift_swordfish",
      "runner_choice" => "stateless",
      "filename_extension" => ".swift"
    },
    "Swift, XCTest" => {
      "image_name" => "cyberdojofoundation/swift_xctest",
      "runner_choice" => "stateful",
      "filename_extension" => ".swift"
    },

    "VHDL, assert" => {
      "image_name" => "cyberdojofoundation/vhdl_assert",
      "runner_choice" => "stateless",
      "filename_extension" => ".vhdl"
    },

    "VisualBasic, NUnit" => {
      "image_name" => "cyberdojofoundation/visual-basic_nunit",
      "runner_choice" => "stateless",
      "filename_extension" => ".vb"
    }
  }

end
