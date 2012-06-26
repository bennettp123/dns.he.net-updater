### dns.he.net powershell dynamic dns updater

A very basic updater for dynamic DNS services provided by <http://dns.he.net/>. Very trivial to convert for use with other dynamic DNS providers.

## Instructions:

 1. Edit updater.ps1 in a text editor, and modify the hostname and password fields.
 2. By default, a custom IP is not sent. If you wish to send a custom IP address, uncomment the two lines below the $myip variable.
 3. If necessary, launch powershell and run the following command: `Set-ExecutionPolicy RemoteSigned`.
 4. Run updater.ps1.
 5. [Optional]: Use the pshelwrapper.vbs when creating a scheduled task to hide the powershell window.
 
License: Freeware.<br />Warranty: None.

Enjoy!