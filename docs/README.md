[![Build Status](https://travis-ci.org/cyber-dojo/storer.svg?branch=master)](https://travis-ci.org/cyber-dojo/storer)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png"
alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/storer docker image

- A docker-containerized micro-service for [cyber-dojo](http://cyber-dojo.org).
- Stores the visible files, output, and traffic-light status of every test event.
- Stores data inside a docker-volume in a docker data-container.

API:
  * All methods receive their named arguments in a json hash.
  * All methods return a json hash.
    * If the method completes, a key equals the method's name.
    * If the method raises an exception, a key equals "exception".

- - - -

## GET sha
Returns the git commit sha used to create the docker image.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sha": "afe46e4bba4c7c5b630ef7fceda52f29001a10da" }
```

- - - -

## GET kata_exists?
Asks whether the kata with the given kata_id exists.
- parameters, eg
```
  { "kata_id": "15B9AD6C42" }
```
- returns true if it does, false if it doesn't, eg
```
  { "kata_exists?": true   }
  { "kata_exists?": false  }
```

- - - -

## POST kata_create
Creates a kata from the given json manifest.
- parameter, eg
```
    { "manifest": {
                   "created": [2017,12,15, 11,13,38],
              "display_name": "C (gcc), assert",
                "image_name": "cyberdojofoundation/gcc_assert",
             "visible_files": {        "hiker.h": "#ifndef HIKER_INCLUDED...",
                                       "hiker.c": "#include \"hiker.h\"...",
                                "hiker.tests.c" : "#include <assert.h>\n...",
                                 "instructions" : "Write a program that...",
                                     "makefile" : "CFLAGS += -I. -Wall...",
                                "cyber-dojo.sh" : "make"
                              },
             "runner_choice": "stateless",
                  "exercise": "Fizz_Buzz",
               "max_seconds": 10,
        "filename_extension": ".c",
                  "tab_size": 4,
      }
    }
```
- returns the id of the kata created from the given manifest, eg
```
  { "kata_create": "A551C528C3"
  }
```

- - - -

## GET kata_manifest
Returns the manifest used to create the kata with the given kata_id.
- parameter, eg
```
  { "kata_id": "A551C528C3" }
```
- returns, eg
```
    { "kata_manifest": {
                   "kata_id": "A551C528C3",
                   "created": [2017,12,15, 11,13,38],
              "display_name": "C (gcc), assert",
                "image_name": "cyberdojofoundation/gcc_assert",
             "visible_files": {       "hiker.h" : "ifndef HIKER_INCLUDED\n...",
                                      "hiker.c" : "#include \"hiker.h\"...",
                                "hiker.tests.c" : "#include <assert.h>\n...",
                                 "instructions" : "Write a program that...",
                                     "makefile" : "CFLAGS += -I. -Wall...",
                                "cyber-dojo.sh" : "make"
                              },
             "runner_choice": "stateless",
                  "exercise": "Fizz_Buzz",
               "max_seconds": 10,
        "filename_extension": ".c",
                  "tab_size": 4
      }
    }
```

- - - -

## GET kata_increments
Returns avatar_increments for each started avatar in the kata with the given kata_id.
- parameter, eg
```
  { "kata_id": "A551C528C3" }
```
- returns, eg
```
  { "kata_increments": {
    'lion': [
        {  "event": "created", "time": [2016,12,5, 11,15,18], "number": 0 },
        { "colour": "red,      "time": [2016,12,6, 12,31,15], "number": 1 },
        { "colour": "green",   "time": [2016,12,6, 12,32,56], "number": 2 },
        { "colour": "amber",   "time": [2016,12,6, 12,43,19], "number": 3 }
    ],
    'tiger': [
        {  "event": "created", "time": [2016,12,5, 11,15,18], "number": 0 },
        { "colour": "amber",   "time": [2016,12,6, 11,16, 2], "number": 1 }
    ]
  }
```

- - - -

## GET sample_id10
Returns a randomly selected kata_id.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sample_id10": "A551C528C3" }
```

- - - -

## GET sample_id2
Returns a randomly selected outer_id.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sample_id2": "A5" }
```

- - - -

## GET katas_completed
Returns the 10-character kata_ids which uniquely complete
the given partial_id (if any).
- parameter, the partial-id to complete, eg
```
  { "partial_id": "A551C5" } # must be at least 6 characters long.
```
- returns, eg
```
  { "katas_completed": [
       "A551C528C3",
       "A551C5DE1A"
      ]
  }
  { "katas_completed": [] }
```

- - - -

## GET katas_completions
Returns all the kata_id completions for the given 2-digit long outer_id.
- parameter, eg
```
  { "outer_id": "A5" }
```
- returns, eg
```
  { "katas_completions": [
       "51C528C3",
       "DA2CDC58",
       "EAFE6E53"
    ]
  }
```

- - - -
- - - -

## GET avatar_exists?
Asks whether the avatar with the given avatar_name
has started in the kata with the given kata_id.
- parameters, eg
```
  {     "kata_id": "15B9AD6C42",
    "avatar_name": "salmon"
  }
```
- returns true if it does, false if it doesn't, eg
```
  { "avatar_exists?": true  }
  { "avatar_exists?": false }
```

- - - -

## POST avatar_start
Attempts to starts an avatar, with a name in the given list, in the kata with the given kata_id.
If successful, returns the name of the started avatar, otherwise null.
- parameters, eg
```
  {      "kata_id": "A551C528C3",
    "avatar_names": [ "lion", "salmon", "rhino" ]
  }
```
- returns the name of the started avatar if successful, otherwise nil, eg
```
  { "avatar_start": "lion" }
  { "avatar_start": null   }
```

- - - -

## GET avatars_started
Returns the names of all avatars who have started in the kata with the given kata_id.
- parameter, eg
```
  { "kata_id": "A551C528C3" }
```
- returns, eg
```
  { "avatars_started": [
      "rhino",
      "cheetah",
      "starfish"
    ]
  }
```

- - - -

## POST avatar_ran_tests
Tells the storer that the avatar with the given avatar_name, in the kata
with the given kata_id, submitted the given visible files, at the given time,
which produced the given stdout, stderr, with the given traffic-light colour.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino",
          "files": {       "hiker.h" : "ifndef HIKER_INCLUDED\n...",
                           "hiker.c" : "#include \"hiker.h\"...",
                     "hiker.tests.c" : "#include <assert.h>\n...",
                      "instructions" : "Write a program that...",
                          "makefile" : "CFLAGS += -I. -Wall...",
                     "cyber-dojo.sh" : "make"
                   }
            "now": [2016,12,6, 12,31,15],
         "stdout": "",
         "stderr": "Assert failed: answer() == 42",
         "colour": "red"
  }
```
Returns avatar_increments, eg
```
  { "avatar_ran_tests": [
      {  "event": "created", "time": [2016,12,5, 11,15,18], "number": 0 },
      { "colour": "red,      "time": [2016,12,6, 12,31,15], "number": 1 }
    ]
  }
```

- - - -

## GET avatar_increments
Returns details of all traffic-lights, for the avatar with the
given avatar_name, in the kata with the given kata_id.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino"
  }
```
- returns, eg
```
  { "avatar_increments": [
      {  "event": "created", "time": [2016,12,5, 11,15,18], "number": 0 },
      { "colour": "red,      "time": [2016,12,6, 12,31,15], "number": 1 },
      { "colour": "green",   "time": [2016,12,6, 12,32,56], "number": 2 },
      { "colour": "amber",   "time": [2016,12,6, 12,43,19], "number": 3 }
    ]
  }
```

- - - -

## GET avatar_visible_files
Returns the most recent set of visible files, for the avatar with the
given avatar_name, in the kata with the given kata_id.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino"
  }
```
- returns, eg
```
  { "avatar_visible_files": {
            "hiker.h" : "ifndef HIKER_INCLUDED\n...",
            "hiker.c" : "#include \"hiker.h\"...",
      "hiker.tests.c" : "#include <assert.h>...",
       "instructions" : "Write a program that...",
           "makefile" : "CFLAGS += -I. -Wall...",
      "cyber-dojo.sh" : "make"
    }
  }
```

- - - -
- - - -

## POST tag_fork
Creates a new kata forked from the visible files of the avatar with the
given avatar_name, in the kata with the given kata_id,
with the given tag number.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino",
            "tag": 2
  }
```
- returns, the id of the forked kata, eg
```
  { "tag_fork": "8EDB6C141A"
  }
```

- - - -

## GET tag_visible_files
Returns the set of visible files, for the avatar with the
given avatar_name, in the kata with the given kata_id,
with the given tag number.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino",
            "tag": 2
  }
```
- returns, eg
```
  { "tag_visible_files": {
             "hiker.h" : "#ifndef HIKER_INCLUDED\n...",
             "hiker.c" : "#include \"hiker.h\"\n...",
       "hiker.tests.c" : "#include <assert.h>\n...",
        "instructions" : "Write a program that...",
            "makefile" : "CFLAGS += -I. -Wall...",
       "cyber-dojo.sh" : "make"
    }
  }
```

- - - -

## GET tags_visible_files
Returns the paired set of visible files for the avatar with the
given avatar_name, in the kata with the given kata_id, with the
given tag numbers.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino",
        "was_tag": 2,
        "now_tag": 3
  }
```
- returns, eg
```
  { "tags_visible_files": {
      "was_files": {
                  "hiker.h" : "#ifndef HIKER_INCLUDED\n...",
                  "hiker.c" : "#include \"hiker.h\"\n...",
            "hiker.tests.c" : "#include <assert.h>\n...",
            "cyber-dojo.sh" : "make",
         ...
      },
      "now_files": {
               "fizzbuzz.h" : "#ifndef FIZZBUZZ_INCLUDED\n...",
               "fizzbuzz.c" : "#include \"fizzbuzz.h\"\n...",
         "fizzbuzz.tests.c" : "#include <assert.h>\n...",
            "cyber-dojo.sh" : "make",
         ...
      }
    }
  }
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to http://cyber-dojo.org](http://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
