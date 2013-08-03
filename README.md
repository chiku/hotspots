[![Build Status](https://secure.travis-ci.org/chiku/hotspots.png?branch=master)](https://travis-ci.org/chiku/hotspots)
[![Build Status](https://drone.io/github.com/chiku/hotspots/status.png)](https://drone.io/github.com/chiku/hotspots/latest)
[![Code Climate](https://codeclimate.com/github/chiku/hotspots.png)](https://codeclimate.com/github/chiku/hotspots)

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
    -m, --message-filter [PIPE SEPARATED]  Pipe separated values to filter files names against each commit message.
                                           All commit messages are allowed when not specified
    -c, --cutoff [CUTOFF]                  The minimum occurrence to consider for a file to appear in the list. Defaults to zero
        --log [LOG LEVEL]                  Log level (debug, info, warn, error, fatal)
    -v, --verbose                          Show verbose output
    -C, --colour, --color                  Show output in colours. The log level should be info or debug for colours
    -h, --help                             Show this message
        --version                          Show version information
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

Contributing
------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, but do not mess with the VERSION. If you want to have your own version, that is fine but bump the version in a commit by itself in another branch so I can ignore it when I pull.
* Send me a pull request.

License
-------

This tool is released under the MIT license. Please refer to LICENSE for more details.
