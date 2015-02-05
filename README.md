### dns.he.net powershell dynamic dns updater

A very basic updater for dynamic DNS services provided by <http://dns.he.net/>.

#### License

MIT

#### Warranty

None. :p

## Instructions

 1. Edit updater.ps1 in a text editor, and modify the hostname and password fields.
 2. If necessary, launch powershell and run the following command: `Set-ExecutionPolicy RemoteSigned`.
 3. Run updater.ps1.
 4. [Optional]: Use the pshellwrapper.vbs when creating a scheduled task to hide the powershell window:
 
### pshellwrapper.vbs usage

    cscript.exe \path\to\pshellwrapper.vbs \path\to\updater.ps1

### Scheduled Task creds

![Scheduled task settings](https://raw.githubusercontent.com/bennettp123/dns.he.net-updater/master/doc/schedtask-sample1.png)

## Enjoy!
