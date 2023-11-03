(*
 * File: IPCfgLib.typ
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of IPCfgLib, licensed under the MIT License.
 *)

TYPE
	IPConfig_Settings_typ : 	STRUCT 
		INADeviceName : STRING[80]; (*Device Name PP main IF = 'IF5' *)
		IPMode : UDINT; (*Static = 0 DHCP =1*)
		IPAddress : STRING[16]; (*IP Address of the Interface*)
		SubnetMask : STRING[16]; (*Subnet mask of the interface*)
		DefaultGateway : STRING[16]; (*AR Default gateway. Needed to reach outside world*)
		HostName : STRING[80]; (*Host name of the PLC*)
		INANode : USINT; (*INA Node Number of the interface*)
		MacAddress : ARRAY[0..5]OF USINT; (*INA Node Number of the interface*)
	END_STRUCT;
	IPConfig_Internal_typ : 	STRUCT 
		Config : IPConfig_Settings_typ;
		GetMode : CfgGetEthConfigMode;
		SetMode : CfgSetEthConfigMode;
		GetIPAddr : CfgGetIPAddr;
		SetIPAddr : CfgSetIPAddr;
		GetSubnetMask : CfgGetSubnetMask;
		SetSubnetMask : CfgSetSubnetMask;
		GetGateway : CfgGetDefaultGateway;
		SetGateway : CfgSetDefaultGateway;
		GetHostName : CfgGetHostName;
		SetHostName : CfgSetHostName;
		GetInaNode : CfgGetInaNode;
		SetInaNode : CfgSetInaNode;
		GetMacAddress : CfgGetMacAddr;
	END_STRUCT;
END_TYPE
