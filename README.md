# Mikrotik emergency restorer

These two scripts create and restore a .backup and .rsc files with current mikrotik condiguration. Use it in cases when you can lose access to you router but for some reason you can't use safe mode.

At first, remember to add two scripts in /system script!!! 

saver.rsc
==========
Restores configuation from file created with loader.rsc

loader.rsc 
==========
This script creates a .backup and .rsc files with current mikrotik condiguration. Use it in cases when you can lose access in you router but for some reason you can't use safe mode.

The script first creates (or modifies if exists) disabled scheduler task which will run after 15 minutes and will execute loader.rsc script. After that creates backups, uploads both files to sftp servers, sets early created schedule as enabled, and print detailed info for schedule.

If you want to use ftp instead of sftp, remember to add mode=ftp in fetch command
 
The idea behind creating disabled task and after a while enabling them, is to make backup with disabled schedule, so we don't need to disable it after emergency restore.

Remember to disable the schedule in case everything is fine

# Usage

/system/scripts/run saver

If schedule looks ok, apply risky changes in mikrotik configuration

If You loose accees to You router, after 15 minutes it will restore a configuration created with saver, before applied risk changes.

If everything is OK, remember to disable test schedule. Or you will resore the previous configuration

# Future improvements

Don't get your hopes up, but if I continue to do "stupid things" with mikrotik configs, maybe I'll come up with an option to automate the scheduler disabling on successful router work after applying the issues. Maybe something with watchdog... I'll think about it when the time comes ;-)

# Copyright

Use everything on You own risk, free of charge, as you want, when you want, for whatever you want and no matter home or commercial use.
