function Get-Webclient
{
	$wc = New-Object Net.WebClient
	$wc.UseDefaultCredentials = $true
	$wc.Proxy.Credentials = $wc.Credentials
	$wc
}

function Get-IPAddresses
{
	$Computer = "."
	$IPconfigset = Get-WmiObject Win32_NetworkAdapterConfiguration
	foreach ($IPConfig in $IPConfigSet) {
		if ($Ipconfig.IPaddress) {
			foreach ($addr in $Ipconfig.Ipaddress) {
				"{0}" -f  $addr;
			}
		} 
	}
}

function Ignore-SLL-Errors
{
	$Provider = New-Object Microsoft.CSharp.CSharpCodeProvider
	$Compiler= $Provider.CreateCompiler()
	$Params = New-Object System.CodeDom.Compiler.CompilerParameters
	$Params.GenerateExecutable = $False
	$Params.GenerateInMemory = $True
	$Params.IncludeDebugInformation = $False
	$Params.ReferencedAssemblies.Add("System.DLL") > $null
	$TASource=@'
		namespace Local.ToolkitExtensions.Net.CertificatePolicy
		{
			public class TrustAll : System.Net.ICertificatePolicy
			{
				public TrustAll() {}
				public bool CheckValidationResult(System.Net.ServicePoint sp,System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Net.WebRequest req, int problem)
				{
					return true;
				}
			}
		}
'@ 
	$TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
	$TAAssembly=$TAResults.CompiledAssembly
	## We create an instance of TrustAll and attach it to the ServicePointManager
	$TrustAll = $TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
	[System.Net.ServicePointManager]::CertificatePolicy = $TrustAll
}

function UseUnsafeHeaderParsing
{
	$netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])
 	if($netAssembly)
	{
		$bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
		$settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")
 		$instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())
 		if($instance)
		{
			$bindingFlags = "NonPublic","Instance"
			$useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)
 			if($useUnsafeHeaderParsingField)
			{
				$useUnsafeHeaderParsingField.SetValue($instance, $true)
			}
		}
	}
}