# Mikrotik_emergency_restorer

At first, remember to add two scripts in /system script!!! 

saver.rsc
==========
Restores configuation from file created with saver.rsc

loader.rsc 
==========
This script creates a .backup and .rsc files with current mikrotik condiguration
Use it in cases when you can lose access in you script but for some reason you can't use safe mode.

The script first creates (or modifies if exists) disabled scheduler task which will run after 15 minutes
and will execute loader.rsc script. After that creates backups, uploads both files to sftp servers
setting early created schedule as enabled, and print detailed info for schedule.

If you want to use ftp instead of sftp, remember to add mode=ftp in fetch command
 
The idea behind creating disabled task and after a while enabling them, is to make backup with disabled
schedule, so we don't need to disable it after emergency restore.

Remember to disable the schedule in case everything is fine

#Usage

/system/scripts/run saver

If schedule looks ok, apply risky changes in mikrotik configuration

If You loose accees to You router, after 15 minutes it will restore a configuration created with saver, before applied risk changes.

If everything is OK, remember to disable test schedule. Or you will resore the previous configuration
