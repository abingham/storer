
The test data
=============

This dir holds five examples of katas used as data for storer tests.
In partcular they are used to test methods which rely on
starter.manifest(language) converting from the old-style manifest.json
format to the new-style manifest.json format. See below.
They are tar-piped into storer.

The five katas are:

42/0BD5D5BE
  style? old (.git dirs)
  avatar? hummingbird
  lights? 0
  { "language":"Python-py.test", ... }
  renaming? no

42/1AFD7EC5
  style? old (.git dirs)
  avatar? wolf
  lights? 1
  { "language":"Ruby-Rspec", ... }
  renaming? yes  'Ruby-RSpec'

42/1F303E80
  style? old (.git dirs)
  avatar? buffalo
  lights? 36
  { "language":"C", ... }
  renaming? yes 'C (gcc)-assert'

42/0B05BA0A
  style? new (no .git dirs)
  avatar? dolphin
  lights? 20
  { "language":"Java-JUnit", ... }
  renaming? no

42/0F2A2979
  style? new (no .git dirs)
  avatar? snake
  lights? 0
  { "language":"PHP-PHPUnit", ... }
  renaming? no



Getting the test data
=====================

The source is the cyber-dojo/converter github repo
which contains the file katas_42.tgz which I untarred to 42/... dirs
  $ cd cyberdojo/storer
  $ tar -xf katas_42.tgz
I then extracted the five katas as follows
  $ ./tar_1_kata.sh 42 0BD5D5BE
  $ ./tar_1_kata.sh 42 1AFD7EC5
  $ ./tar_1_kata.sh 42 1F303E80
  $ ./tar_1_kata.sh 42 0B05BA0A
  $ ./tar_1_kata.sh 42 0F2A2979


Alternatively you could get katas out of a running cyber-dojo server
using something like this:

   CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
   VOLUME_PATH=/usr/src/cyber-dojo/katas
   OUTER=5A
   INNER=0F824303
   docker run --rm \
     --volumes-from ${CONTAINER_NAME}:ro \
     --volume $(pwd):/backup:rw \
     alpine:latest \
     tar -zcf /backup/backup_5A0F824303.tgz -C ${VOLUME_PATH}/5A 0F824303



Kata manifest formats
=====================

Old-style kata manifest.json files
----------------------------------
Contain the following 7 keys
      "id":                  "340B87D5BE",
      "created":             [2015,9,9,5,29,38],
      "language":            "Python-py.test",
      "exercise":            "Fizz_Buzz_Plus"
      "tab_size":            4,
      "visible_files":       {...},
      "unit_test_framework": "python_pytest"
      "browser":             "..." (only in really old katas)

Note that they do _not_ contain the image_name key
which has to be retrieved via starter.manifest(language).
This couples them to starter.


New-style kata manifest.json files
----------------------------------
Contain the following keys
      "id":                  "0587D5BE87",
      "created":             [2017,11,23,5,29,38],
      "language":            "Python-py.test",
      "exercise":            "Fizz_Buzz_Plus"
      "tab_size":            4,
      "visible_files":       {...},
      "runner_choice":       "stateless",
      "image_name":          "cyberdojofoundation/python_behave",
      "display_name":        "Python, behave",
      "filename_extension":  ".py",
      "progress_regexs":     [],
      "highlight_filenames": [],
      "lowlight_filenames":  [...],

Note that they _do_ contain the image_name key
and are thus are not coupled to starter.