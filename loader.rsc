## Restore configuation from a file created with saver.rsc
## 

### 
### Set admin password
:global adminpass "mypassword"

# getting router ID
:global id [/system/identity/get name]

#executes restore script
:execute {/system backup load name="flash/$id-last.backup" password="$adminpass";}
:delay 1
:put y
