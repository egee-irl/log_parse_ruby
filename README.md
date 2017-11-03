# log_parse_ruby

Quick little log parser for domain-specific web logs.

Just pass the path to your web log in as an argument like so: ``ruby main.rb my.log``.

Note - This log parser requires Ruby version 2.4.x and has been tested with Apache 2.2 combined log format specification. Submit an issue or PR if you encounter an issue with a different log format.

There's also a handy little IP log to csv converter script in here. Assuming you have ``curl``, ``sed``, and ``perl`` installed, it should run on any POSIX system 👍.
