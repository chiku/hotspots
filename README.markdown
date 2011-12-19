Overview
--------

This program helps in identifying files with maximum churn in a git repository. The more the number of changes made to a file, the more likelyhood of the file being a source of bug. If the same file is modified many times for bug fixes, it indicates that the file needs some refactoring or redesign love.


Dependencies
------------

This script depends on ruby. The ruby executable should be in your execution path for the script to run.

Syntax
------

``` script
ruby hotspot.rb <Search pattern to include> [Path to repository] [Min. cutoff for occurance] [Time in days]
ruby hoyspot.rb <--help | -h>
```

<...> denotes a compulsory argument and [...] denotes an optional argument.

The search pattern is a compulsary argument and can be a regular expression.

The default path to repository is the current repository. The path should point to a git repository.

The default minimum cutoff, below which number of modifications to file won't be considered is zero.

The default maximum time-period of days for which modifications to a file is tracked is 15.

For help use *one* of the following
``` script
ruby hotspot.rb --help
ruby hotspot.rb -h
```

Examples
--------

This will give you all file names that contain '.c' and have been modified at least once in the past 15 days in the git repository pointed to by the current path.

``` script
ruby hotspot.rb .c
```

This will give you all file names that contain '.rb' and have been modified at least thrice in the past 5 days in git repository present in 'rails' directory.

``` script
ruby hotspot.rb .rb rails 3 5
```

Running tests
-------------

``` script
ruby test/hotspot_test.rb
```

License
-------

This script is released under the MIT license. Please refer to LICENSE for more details.
