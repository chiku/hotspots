current
-------

* Use default options when invoked as a library
* Restructure interfaces for Logger, ExitStrategy & Hotspots. The older classes, modules and methods are still available

v0.1.1
------

* Sort for an array of array via spaceship operator returns different result on each run on ruby 1.8.7. Store has a string representation breaks intermittently on 1.8.7. Tests fail intermittently on 1.8.7. So support for ruby 1.9.x only
* Simplify Rakefile
* Pull out a minitest_helper
* Allow gem to be used as a library

v0.1.0
------

* Version bump to force gem install to download latest version

v0.0.13
-------

* Fix switch 'since' for git 1.7.2.5 (Thanks to Phil Hofmann https://github.com/branch14)
* Display a warning and run tests without reporting coverage if simplecov is not present
* Change format in verbose mode

v0.0.12
-------

* Make compatible with ruby 1.8.7

v0.0.11
-------

* Default task is to run coverage report
* Tolerate git versions that bomb when --grep option is empty

v0.0.10
-------

* Handle '\r' line endings
* *Don't disregard file-name case*
* Tests and coverage via rake

v0.0.9
------

* Add installation procedure
* Change website link
* Bump up version

v0.0.8
------

* Initial release
