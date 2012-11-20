Overview
--------

This program helps in identifying files with maximum churn in a git repository. The more the number of changes made to a file, the more likelyhood of the file being a source of bug. If the same file is modified many times for bug fixes, it indicates that the file needs some refactoring or redesign love.


Dependencies
------------

This script depends on ruby. Obviously it also depends on git. Ruby and git executables should be in your execution path for the script to run.

Installation
------------

``` script
gem install hotspots
```

Syntax
------

``` script
Usage: hotspots [options]

Specific options:
    -t, --time [TIME]                      Time in days to scan the repository for. Defaults to fifteen
    -r, --repository [PATH]                Path to the repository to scan. Defaults to current path
    -f, --file-filter [REGEX]              Regular expression to filtering file names. All files are allowed when not specified
    -m, --message-filter [PIPE SEPARATED]  Values to filter files names against each commit message separated by pipe.
                                           All files are allowed when not specified
    -c, --cutoff [CUTOFF]                  The minimum occurrence to consider for a file to appear in the list. Defaults to zero
    -v, --verbose                          Show verbose output
        --version                          Show version information
    -h, --help                             Show this message
```

Examples
--------

This will give you all file names that contain '.c' and have been modified at least once in the past 15 days in the git repository pointed to by the current path.

``` script
hotspots --file-filter "/.c"
```

*Note that the dot "." is escaped as it is a regular expression matcher.*

This will give you all file names that contain '.rb' and have been modified at least thrice in the past 5 days in git repository present in 'rails' directory.

``` script
hotspots --file-filter "/.rb" --path rails --cutoff 3 --time 5
```

Running tests
-------------

Clone the repository and run the following command from the repository.

``` script
gem install simplecov
rake
```

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
