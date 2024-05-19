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


### Change data in next 5 non commented rows
# To upload files to sftp server, enter sftpuser If empty - will skip upload
:local sftpuser ""
:local sftppass "my_sftp_pass"
:local sftpurl "sftp://my.sftp.server:server_port/path/"
:local safetytime 5
# if router have flash folder - "flash" else ""
:local flashpath ""


# ====== End of changes
:global m1 00
:global h1 00
:local id [/system/identity/get name]


# Get system time
:local time [/system clock get time]
:local hour [:pick $time 0 2]
:local minute [:pick $time 3 5]
:if ($minute>=60-$safetytime) do={
  :set h1 ($hour+1)
  :set m1 ($minute-(60-$safetytime))
} else={
  :set m1 ($minute+$safetytime)
  :set h1 ($hour)
}

## Creates or modifies schedule with name test, wgich will run after 15 minutes to start
## a loader.rsc script. 
:if ([system/scheduler/find name=test] = "") do={/system/scheduler/add name=test}
/system/scheduler/set [find name=test] start-date=[/system/clock/get date] start-time="$h1:$m1:00" interval="00:$safetytime:00" on-event="/system/script/run loader" disabled=yes



## Creates .backup and .rsc files with name router_id-last.backup (.rsc) in folder flash/
/system/backup/save name="$flashpath/$id-last"
/export file="$flashpath/$id-last" show-sensitive 
#/export file="$id-last" show-sensitive 

if ($ftpuser > "") do= {
   ##Uploads files to SFTP server.
   /tool/fetch upload=yes url="$sftpurl$id-last.rsc" src-path="$flashpath/$id-last.rsc" user="$sftpuser" password="$sftppass"
   /tool/fetch upload=yes url="$sftpurl$id-last.backup" src-path="$flashpath/$id-last.backup" user="$sftpuser" password="$sftppass"
   :delay 2s
}

# Enabling schedule
/system/scheduler/set [find name=test] disabled=no

# Print detailed info about schedule
/system/scheduler/print detail where name=test
