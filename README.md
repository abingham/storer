
[![Build Status](https://travis-ci.org/cyber-dojo/storer.svg?branch=master)]
(https://travis-ci.org/cyber-dojo/storer)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png"
alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/storer docker image

- A micro-service for [cyber-dojo](http://cyber-dojo.org)
- Stores the visible files associated with every avatar test event.
- API:
  * All methods return a json object with a single key
  * If successful, the key equals the method's name.
  * If unsuccessful, the key equals "exception".

- - - -

## path
Returns the storer's root path.
- returns eg
```
  { "path": "/usr/src/cyber-dojo/katas"  }
```

- - - -

## completed
If it exists, returns the 10-digit kata_id which uniquely completes
the given id, otherwise nil.
- parameter
```
  id   eg "A551C5", must be at least 6 characters long.
```
- returns eg
```
  { "completed": "A551C528C3"  }
```

## completions
Returns all the kata_id's starting with the given 2-digit long id.
- parameter
```
  id  eg "A5"
```
- returns eg
```
  { "completions": [ "A551C528C3", "A5DA2CDC58", "A5EAFE6E53" ]  }
```

- - - -

## create_kata
Creates a kata from the given json manifest.
- parameter, eg
```
    {
      "kata_id"   : "A551C528C3",
      "image_name": "cyberdojofoundation/gcc_assert",
      "visible_files": { "hiker.h": "int answer()...", ... },
      "filename_extension": ".c",
      "tab_size": 4,
      ...
    }
```

- - - -

## kata_manifest
Returns the manifest used to create the kata with the given kata_id.
- parameter
```
  kata_id  eg "A551C528C3"
```
- returns eg
```
    { "kata_manifest": {
        "kata_id"   : "a551c528c3",
        "image_name": "cyberdojofoundation/gcc_assert",
        "visible_files": { "hiker.h": "int answer()...", ... },
        "filename_extension": ".c",
        "tab_size": 4,
        ...
      }
    }
```

- - - -

## start_avatar
Attempts to starts an avatar in the kata with the given kata_id.
If successful, returns the name of the started avatar, otherwise nil.
- parameters
```
  kata_id       eg "A551C528C3"
  avatar_names  eg [ "lion", "salmon", "rhino" ]
```
- returns the name of the started avatar if successful, otherwise nil.
```
  { "start_avatar": "lion" }
  { "start_avatar": nil    }
```

- - - -

## started_avatars
Returns the names of all avatars who have started in the kata with the given kata_id.
- parameter
```
  kata_id  eg "A551C528C3"
```
- returns eg
```
  { "started_avatars": [ "rhino", "cheetah", "starfish" ] }
```

- - - -

## avatar_ran_tests
Tells the storer that the given avatar, in the kata with the given kata_id,
submitted the given visible files, at the given time, which produced the given
output, with the given colour.
- parameters
```
  kata_id     eg "A551C528C3"
  avatar_name eg "rhino"
  files       eg { "hiker.h": "int answer()...", ... }
  now         eg [2016,12,6,12,31,15]
  output      eg "Assert failed: answer() == 42"
  colour      eg "red"
```

- - - -

## avatar_increments
Returns details of all traffic-lights, for the given avatar,
in the kata with the given kata_id.
- parameters
```
  kata_id     eg "A551C528C3"
  avatar_name eg "rhino"
```
- returns eg
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
Returns the most recent set of visible files, for the given avatar,
in the kata with the given kata_id.
- parameters
```
  kata_id     eg "A551C528C3"
  avatar_name eg "rhino"
```
- returns eg
```
  { "avatar_visible_files": {
      "hiker.h"       : "int answer()...",
      "hiker.c"       : "#include \"hiker.h\"...",
      "hiker.tests.c" : "#include <assert.h>...",
      "cyber-dojo.sh" : "make --always-make"
    }
  }
```

- - - -

## tag_visible_files
Returns the set of visible files, for the given avatar,
in the kata with the given kata_id, with the given tag number.
- parameters
```
  kata_id     eg "A551C528C3"
  avatar_name eg "rhino"
  tag         eg "2"
```
- returns eg
```
  { "tag_visible_files": {
       "hiker.h"       : "int answer()...",
       "hiker.c"       : "#include \"hiker.h\"...",
       "hiker.tests.c" : "#include <assert.h>...",
       "cyber-dojo.sh" : "make --always-make"
    }
  }
```

- - - -

## tags_visible_files
Returns the paired set of visible files for the given avatar,
in the kata with the given kata_id, with the given tag numbers.
- parameters
```
  kata_id     eg "A551C528C3"
  avatar_name eg "rhino"
  was_tag     eg "2"
  now_tag     eg "3"
```
- returns eg
```
  { "tags_visible_files": {
      "was_files": {
         "hiker.h"       : "int answer()...",
         "hiker.c"       : "#include \"hiker.h\"...",
         "hiker.tests.c" : "#include <assert.h>...",
         "cyber-dojo.sh" : "make --always-make"
      },
      "now_files": {
         "fizzbuzz.h"       : "#ifndef FIZZBUZZ_INCLUDED...",
         "fizzbuzz.c"       : "#include \"fizzbuzz.h\"...",
         "fizzbuzz.tests.c" : "#include <assert.h>...",
         "cyber-dojo.sh"    : "make --always-make"
      }
    }
  }
```

