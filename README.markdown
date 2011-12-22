Overview
--------

This program helps in identifying files with maximum churn in a git repository. The more the number of changes made to a file, the more likelyhood of the file being a source of bug. If the same file is modified many times for bug fixes, it indicates that the file needs some refactoring or redesign love.


Dependencies
------------

This script depends on ruby. The ruby executable should be in your execution path for the script to run.

Syntax
------

``` script
Usage: ruby hotspots [options]

Specific options:
    -t, --time [TIME]                Time is days to scan the repository for. Defaults to fifteen
    -r, --repository [PATH]          The path to the current repository. Defaults to current path
    -f, --filter [REGEX]             The regular expression for file to filter with. All files are allowed when not specified
    -c, --cutoff [CUTOFF]            The minimum occurance to consider for a file to appear in the list. Defaults to zero
    -h, --help                       Show this message
```

Examples
--------

This will give you all file names that contain '.c' and have been modified at least once in the past 15 days in the git repository pointed to by the current path.

``` script
ruby hotspots --filter "/.c"
```

*Note that the dot "." is escaped as it is a regular expression matcher.*

This will give you all file names that contain '.rb' and have been modified at least thrice in the past 5 days in git repository present in 'rails' directory.

``` script
ruby hotspots --filter "/.rb" --path rails --cutoff 3 --time 5
```

Running tests
-------------

``` script
ruby test/hotspot_test.rb
```

License
-------

This script is released under the MIT license. Please refer to LICENSE for more details.
