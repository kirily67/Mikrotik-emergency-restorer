# This script creates a .backup and .rsc files with current mikrotik condiguration
# Use it in cases when you can lose access in you script but for some reason you can't use safe mode.
#
# The script first creates (or modifies if exists) disabled scheduler task which will run after 15 minutes
# and will execute loader.rsc script. After that creates backups, uploads both files to sftp servers
# setting early created schedule as enabled, and print detailed info for schedule.
#
# If you want to use ftp instead of sftp, remember to add mode=ftp in fetch command
# 
# The idea behind creating disabled task and after a while enabling them, is to make backup with disabled
# schedule, so we don't need to disable it after emergency restore.
#
# Remember to disable the schedule in case everything is fine


### Change date in next 3 rows
:local sftpuser "my_sftp_user"
:local sftppass "my_sftp_pass"
:local sftpurl "sftp://my.sftp.server:server_port/path/"


# ====== End of changes
:global m1 00
:global h1 00
:local id [/system/identity/get name]


# Get system time
:local time [/system clock get time]
:local hour [:pick $time 0 2]
:local minute [:pick $time 3 5]
:if ($minute>=45) do={
  :set h1 ($hour)
  :set m1 ($minute-45)
} else={
  :set m1 ($minute+15)
  :set h1 ($hour)
}

## Creates or modifies schedule with name test, wgich will run after 15 minutes to start
## a loader.rsc script. 
:if ([system/scheduler/find name=test] = "") do={/system/scheduler/add name=test}
/system/scheduler/set [find name=test] start-date=[/system/clock/get date] start-time="$h1:$m1:00" interval="00:15:00" on-event="/system/script/run loader" disabled=yes

## Creates .backup and .rsc files with name router_id-last.backup (.rsc) in folder flash/
/system/backup/save name="flash/$id-last"
/system/export file="flash/$id-last" show-sensitive 

##Uploads files to SFTP server. If you dont like to do that, comment next 3 lines
/tool/fetch upload=yes url="$sftpurl$id-last.rsc" src-path="flash/$id-last.rsc" user="$sftpuser" password="$sftppass"
/tool/fetch upload=yes url="$sftpurl$id-last.backup" src-path="flash/$id-last.backup" user="$sftpuser" password="$sftppass"
:delay 2s

# Enabling schedule
/system/scheduler/set [find name=test] disabled=no

# Print detailed info about schedule
/system/scheduler/print detail where name=test
