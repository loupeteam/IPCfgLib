(********************************************************************
 * COPYRIGHT -- ARG
 ********************************************************************
 * Library: IPSettings
 * File: IPSettings.fun
 * Author: Administrator
 * Created: March 01, 2011
 ********************************************************************
 * Functions and function blocks of library IPSettings
 ********************************************************************)

FUNCTION_BLOCK IPConfig (*Basic function block for managing IP settings*)
	VAR_INPUT
		INADeviceName : STRING[80]; (*Device Name PP main IF = 'IF5' *)
		Refresh : BOOL; (*Refreshes all parameters*)
		ResetToDefaults : BOOL; (*Command to reset all settings to the defaults from the AS project (restart is required)*)
		IPMode : UDINT; (*Static = 0 DHCP =1*)
		IPAddress : STRING[16]; (*IP Address of the Interface*)
		SubnetMask : STRING[16]; (*Subnet mask of the interface*)
		DefaultGateway : STRING[16]; (*AR Default gateway. Needed to reach outside world*)
		HostName : STRING[80]; (*Host name of the PLC*)
		INANode : USINT; (*INA Node Number of the interface*)
	END_VAR
	VAR_OUTPUT
		MacAddress : STRING[16]; (*All settings are valid and current*)
		Valid : BOOL; (*All settings are valid and current*)
	END_VAR
	VAR
		internal : IPConfig_Internal_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK WinShare (*Implements a link to a Windows network drive*)
	VAR_INPUT
		Enable : BOOL; (*Enables the function block.*)
		FileDevice : STRING[20]; (*Name of the file device to link. This is used for subsequent file IO operations (FileOpen, FileRead, etc.).*)
		IPAddress : STRING[15]; (*IP address of the server.*)
		ShareName : STRING[20]; (*CIFS directory on the remote computer which should be mounted.*)
		UserName : STRING[20]; (*User name on the server.*)
		Password : STRING[20]; (*Password of the user on the server.*)
	END_VAR
	VAR_OUTPUT
		Status : UINT; (*Error code (0 = no error).*)
	END_VAR
	VAR
		tempString : STRING[250];
		DevUnlink_0 : DevUnlink;
		DevLink_0 : DevLink;
		intipAddress : STRING[15];
	END_VAR
END_FUNCTION_BLOCK
