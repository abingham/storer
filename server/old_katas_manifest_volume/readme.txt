
This dir holds three examples of katas with old-style kata manifests.
These are volume-mounted into storer to provide data for
methods which convert from the old-style manifest.json format
to the new-style manifest.json format.

The source of these manifests is the cyber-dojo/converter github repo
which contains the file katas_42.tgz which untars to 42/... dirs.

The three manifests are:

42/0BD5D5BE/manifest.json
  { "language":"Python-py.test", ... }

42/1AFD7EC5/manifest.json
  { "language":"Ruby-Rspec", ... }

42/1F303E80/manifest.json
  { "language":"C", ... }

starter.manifest('Python-py.test') requires no renaming
starter.manifest('Ruby-Rspec')     requires renaming
starter.manifest('C')              requires renaming


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
      "browser":             "..." (only in very old katas)

Note that they do _not_ contain the image_name key
which has to be retrieved from starter. This couples
them to starter.


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