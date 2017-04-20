
<img width="707" alt="cyber-dojo-screen-shot" src="https://cloud.githubusercontent.com/assets/252118/25101292/9bdca322-23ab-11e7-9acb-0aa5f9c5e005.png">

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to http://cyber-dojo.org](http://cyber-dojo.org).

- - - -

[![Build Status](https://travis-ci.org/cyber-dojo/storer.svg?branch=master)](https://travis-ci.org/cyber-dojo/storer)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png"
alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/storer docker image

- A micro-service for [cyber-dojo](http://cyber-dojo.org)
- Stores the visible files, output, and traffic-light status of every avatar test event.

API:
  * All methods receive their named arguments in a json hash.
  * All methods return a json hash with a single key.
    * If the method completes, the key equals the method's name.
    * If the method raises an exception, the key equals "exception".

- - - -

## path
No parameters. Returns the storer's root path, eg
```
  { "path": "/usr/src/cyber-dojo/katas"  }
```

- - - -
- - - -

## kata_exists?
Asks whether the kata with the given kata_id exists.
- parameters, eg
```
  { "image_name": "cyberdojofoundation/gcc_assert",
       "kata_id": "15B9AD6C42"
  }
```
- returns true if it does, false if it doesn't.
```
  { "kata_exists?": true   }
  { "kata_exists?": false  }
```

- - - -

## create_kata
Creates a kata from the given json manifest.
- parameter, eg
```
    {
                 "kata_id": "A551C528C3",
              "image_name": "cyberdojofoundation/gcc_assert",
           "visible_files": {        "hiker.h": "#ifndef HIKER_INCLUDED...",
                                     "hiker.c": "#include \"hiker.h\"...",
                              "hiker.tests.c" : "#include <assert.h>\n...",
                              "cyber-dojo.sh" : "make --always-make"
                            },
      "filename_extension": ".c",
                "tab_size": 4,
      ...
    }
```

- - - -

## kata_manifest
Returns the manifest used to create the kata with the given kata_id.
- parameter, eg
```
  { "kata_id": "A551C528C3" }
```
- returns, eg
```
    { "kata_manifest": {
                   "kata_id": "a551c528c3",
                "image_name": "cyberdojofoundation/gcc_assert",
             "visible_files": {        "hiker.h": "ifndef HIKER_INCLUDED\n...",
                                       "hiker.c": "#include \"hiker.h\"...",
                                "hiker.tests.c" : "#include <assert.h>\n...",
                                "cyber-dojo.sh" : "make --always-make"
                              },
        "filename_extension": ".c",
                  "tab_size": 4,
        ...
      }
    }
```

- - - -

## completed
If it exists, returns the 10-digit kata_id which uniquely completes
the given kata_id, otherwise leaves it unchanged.
- parameter, eg
```
  { "kata_id": "A551C5" } # must be at least 6 characters long.
```
- returns, eg
```
  { "completed": "A551C528C3"  } # completed
  { "completed": "A551C5"      } # not completed
```

- - - -

## completions
Returns all the kata_id's starting with the given 2-digit long kata_id.
- parameter, eg
```
  { "kata_id": "A5" }
```
- returns, eg
```
  { "completions": [ "A551C528C3", "A5DA2CDC58", "A5EAFE6E53" ]  }
  { "completions": [ ]  }
```

- - - -
- - - -

## avatar_exists?
Asks whether the avatar with the given avatar_name
has started in the kata with the given kata_id.
- parameters, eg
```
  {     "kata_id": "15B9AD6C42",
    "avatar_name": "salmon"
  }
```
- returns true if it does, false if it doesn't
```
  { "avatar_exists?": true   }
  { "avatar_exists?": false  }
```

- - - -

## start_avatar
Attempts to starts an avatar, with a name in the given list, in the kata with the given kata_id.
If successful, returns the name of the started avatar, otherwise "nil".
- parameters, eg
```
  {      "kata_id": "A551C528C3",
    "avatar_names": [ "lion", "salmon", "rhino" ]
  }
```
- returns the name of the started avatar if successful, otherwise nil, eg
```
  { "start_avatar": "lion" }
  { "start_avatar": "nil"  }
```

- - - -

## started_avatars
Returns the names of all avatars who have started in the kata with the given kata_id.
- parameter, eg
```
  { "kata_id": "A551C528C3" }
```
- returns, eg
```
  { "started_avatars": [ "rhino", "cheetah", "starfish" ] }
```

- - - -
- - - -

## avatar_ran_tests
Tells the storer that the avatar with the given avatar_name, in the kata
with the given kata_id, submitted the given visible files, at the given time,
which produced the given output, with the given colour.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino",
          "files": {        "hiker.h": "ifndef HIKER_INCLUDED\n...",
                            "hiker.c": "#include \"hiker.h\"...",
                     "hiker.tests.c" : "#include <assert.h>\n...",
                     "cyber-dojo.sh" : "make --always-make"
                   }
            "now": [2016,12,6,12,31,15],
         "output": "Assert failed: answer() == 42",
         "colour": "red"
  }
```

- - - -

## avatar_increments
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
      {  "event": "created", "time": [2016,12,5,11,15,18], "number": 0 },
      { "colour": "red,      "time": [2016,12,6,12,31,15], "number": 1 },
      { "colour": "green",   "time": [2016,12,6,12,32,56], "number": 2 },
      { "colour": "amber",   "time": [2016,12,6,12,43,19], "number": 3 }
    ]
  }
```

- - - -

## avatar_visible_files
Returns the most recent set of visible files, for the avatar with the
given avatar_name_, in the kata with the given kata_id.
- parameters, eg
```
  {     "kata_id": "A551C528C3",
    "avatar_name": "rhino"
  }
```
- returns, eg
```
  { "avatar_visible_files": {
      "hiker.h"       : "ifndef HIKER_INCLUDED\n...",
      "hiker.c"       : "#include \"hiker.h\"...",
      "hiker.tests.c" : "#include <assert.h>...",
      "cyber-dojo.sh" : "make --always-make"
    }
  }
```

- - - -

## tag_visible_files
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
       "hiker.h"       : "#ifndef HIKER_INCLUDED\n...",
       "hiker.c"       : "#include \"hiker.h\"\n...",
       "hiker.tests.c" : "#include <assert.h>\n...",
       "cyber-dojo.sh" : "make --always-make"
    }
  }
```

- - - -

## tags_visible_files
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
         "hiker.h"       : "#ifndef HIKER_INCLUDED\n...",
         "hiker.c"       : "#include \"hiker.h\"\n...",
         "hiker.tests.c" : "#include <assert.h>\n...",
         "cyber-dojo.sh" : "make --always-make"
      },
      "now_files": {
         "fizzbuzz.h"       : "#ifndef FIZZBUZZ_INCLUDED\n...",
         "fizzbuzz.c"       : "#include \"fizzbuzz.h\"\n...",
         "fizzbuzz.tests.c" : "#include <assert.h>\n...",
         "cyber-dojo.sh"    : "make --always-make"
      }
    }
  }
```
