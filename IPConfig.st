(*
 * File: IPConfig.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of IPCfgLib, licensed under the MIT License.
 *)


(* Device change			DONE and TESTED DFB 20130724 *)

(* Refresh					DONE and TESTED DFB 20130723 *)

(* ResetToDefaults 			DONE and TESTED DFB 20130723 *)

(* IPMode					DONE and TESTED DFB 20130723 *)
	(* Set					DONE and TESTED DFB 20130723 *)
		(* To DHCP			DONE and TESTED DFB 20130723 *)
		(* To manual		DONE and TESTED DFB 20130723 *)
	(* Get					DONE and TESTED DFB 20130723 *)

(* IPAddress				DONE and TESTED DFB 20130723 *)
	(* Set					DONE and TESTED DFB 20130723 *)
	(* Get					DONE and TESTED DFB 20130723 *)

(* SubnetMask				DONE and TESTED DFB 20130723 *)
	(* Set					DONE and TESTED DFB 20130723 *)
	(* Get					DONE and TESTED DFB 20130723 *)

(* DefaultGateway			DONE and TESTED DFB 20130723 *)
	(* Set					DONE and TESTED DFB 20130723 *)
	(* Get					DONE and TESTED DFB 20130723 *)

(* HostName					DONE and TESTED DFB 20130723 *)
	(* Set					DONE and TESTED DFB 20130723 *)
	(* Get					DONE and TESTED DFB 20130723 *)

(* INA_Node					DONE and TESTED DFB 20130724 *)
	(* Set					DONE and TESTED DFB 20130724 *)
	(* Get					DONE and TESTED DFB 20130724 *)
	
(* Valid status				DONE and TESTED DFB 20130724 *)


FUNCTION_BLOCK IPConfig


// Refresh values on CMD or change of Device

	IF 	NOT	(INADeviceName = internal.Config.INADeviceName)	
		OR	Refresh 
		THEN
		
		ToUpper(ADR(INADeviceName));
		
		internal.Config.INADeviceName:=	INADeviceName;
	
		Refresh:=	0;

		internal.GetMode.enable:=		1;
		internal.GetIPAddr.enable:=		1;
		internal.GetSubnetMask.enable:=	1;
		internal.GetGateway.enable:=	1;
		internal.GetHostName.enable:=	1;
		internal.GetInaNode.enable:=	1;
		internal.GetMacAddress.enable:= 1;
	END_IF	


	//Clear non-volatile settings. Project settings will be used on restart.

	IF ResetToDefaults THEN
	
		ResetToDefaults:=	0;
	
		CfgClearNV();
	
	END_IF	


	//---------------------------------------------------------------------------
	// Get values
	//---------------------------------------------------------------------------


	// Get values to internal config 
	// then copy from internal to external 
	// if the FUB finishes without error


	// Ethernet Mode

	internal.GetMode.pDevice:=	ADR(INADeviceName);
	internal.GetMode();

	IF 	internal.GetMode.status = ERR_OK 
		THEN 
	
		internal.Config.IPMode:=	internal.GetMode.ConfigMode;
		IPMode:=	internal.Config.IPMode;
		internal.GetMode.enable:=	0;
	
	END_IF	


	// IP Address

	internal.GetIPAddr.Len:=		SIZEOF(internal.Config.IPAddress);	
	internal.GetIPAddr.pDevice:= 	ADR(INADeviceName);
	internal.GetIPAddr.pIPAddr:=	ADR(internal.Config.IPAddress);
	internal.GetIPAddr();

	IF 	internal.GetIPAddr.status = ERR_OK 
		THEN
	
		IPAddress:=	internal.Config.IPAddress;
		internal.GetIPAddr.enable:=	0;
	
	END_IF


	// Subnet Mask

	internal.GetSubnetMask.Len:=			SIZEOF(internal.Config.SubnetMask);
	internal.GetSubnetMask.pDevice:= 		ADR(INADeviceName);
	internal.GetSubnetMask.pSubnetMask:=	ADR(internal.Config.SubnetMask);
	internal.GetSubnetMask();

	IF 	internal.GetSubnetMask.status = ERR_OK 
		THEN 
	
		SubnetMask:=	internal.Config.SubnetMask;
		internal.GetSubnetMask.enable:=	0;
	
	END_IF


	// Gateway

	internal.GetGateway.Len:= 		SIZEOF(internal.Config.DefaultGateway);	
	internal.GetGateway.pDevice:=	ADR(INADeviceName);
	internal.GetGateway.pGateway:=	ADR(internal.Config.DefaultGateway);
	internal.GetGateway();

	IF 	internal.GetGateway.status = ERR_OK 
		THEN
	
		DefaultGateway:=	internal.Config.DefaultGateway;	
		internal.GetGateway.enable:= 	0;
	
	END_IF


	// Host Name

	internal.GetHostName.Len:=			SIZEOF(internal.Config.HostName);	
	internal.GetHostName.pHostName:=	ADR(internal.Config.HostName);
	internal.GetHostName();

	IF 	internal.GetHostName.status = ERR_OK 
		THEN

		HostName:=	internal.Config.HostName;
		internal.GetHostName.enable:=	0;

	END_IF


	// INA Node

	internal.GetInaNode.pDevice:=	ADR(INADeviceName);
	internal.GetInaNode();

	IF 	internal.GetInaNode.status = ERR_OK 
		THEN 
	
		internal.Config.INANode:=	internal.GetInaNode.InaNode;
		INANode:=	internal.Config.INANode;
		internal.GetInaNode.enable:=	0;
	
	END_IF

	// Mac Address

	internal.GetMacAddress.pDevice:= ADR(INADeviceName);
	internal.GetMacAddress.Len:= 	 SIZEOF(internal.Config.MacAddress);
	internal.GetMacAddress.pMacAddr:=ADR(internal.Config.MacAddress);
	internal.GetMacAddress();
	
	IF internal.GetMacAddress.status = ERR_OK
		THEN
		internal.GetMacAddress.enable:=1;
		ByteToHexString(ADR(internal.Config.MacAddress),internal.GetMacAddress.Len,ADR(MacAddress));		
	END_IF

	//---------------------------------------------------------------------------
	// Set Values
	//---------------------------------------------------------------------------


	// Set values from external config
	// then reset external values and get
	// if the FUB finishes without error


	// Ethernet Mode

	IF	NOT (IPMode = internal.Config.IPMode)
		AND NOT internal.GetMode.enable
		THEN
	
		internal.SetMode.enable	:=	1;
	
	END_IF

	internal.SetMode.ConfigMode:=	IPMode;
	internal.SetMode.pDevice:=		ADR(INADeviceName);
	internal.SetMode.Option:=		cfgOPTION_NON_VOLATILE;	
	internal.SetMode();

	IF 	internal.SetMode.status = ERR_OK 
		THEN
	
		internal.GetMode.enable:=	1;
		internal.SetMode.enable:=	0;

		IF( IPMode = cfgCONFIGMODE_DHCPCLIENT )THEN

			// If mode changes to DHCP client, need to GET 
			// IPAddress, SubnetMask, and Gateway 
			// (get to internal config, copy to external)
	
			internal.GetIPAddr.enable:=		1;
			internal.GetSubnetMask.enable:=	1;
			internal.GetGateway.enable:=	1;
		
		ELSE

			// If mode changes to static, need to SET
			// IPAddress, SubnetMask, and Gateway 
			// (set from external, then get)
	
			internal.SetIPAddr.enable:=		1;
			internal.SetSubnetMask.enable:=	1;
			internal.SetGateway.enable:=	1;
	
		END_IF
	
		internal.GetHostName.enable:=	1;
		internal.GetInaNode.enable:=	1;
				
	END_IF

	// IP Address

	IF 	NOT (IPAddress =  internal.Config.IPAddress)
		AND NOT internal.GetIPAddr.enable	
		THEN
	
		internal.SetIPAddr.enable:=	1;
	
	END_IF

	internal.SetIPAddr.pDevice:=	ADR(INADeviceName);		
	internal.SetIPAddr.pIPAddr:=	ADR(IPAddress);
	internal.SetIPAddr.Option:=		cfgOPTION_NON_VOLATILE;
	internal.SetIPAddr();
	
	IF 	internal.SetIPAddr.status = ERR_OK 
		THEN
	
		internal.GetIPAddr.enable:=	1;	
		internal.SetIPAddr.enable:=	0;
		IPAddress:=	'';
	
	END_IF


	// Subnet Mask

	IF 	NOT (SubnetMask = internal.Config.SubnetMask) 	
		AND NOT	internal.GetSubnetMask.enable
		THEN
	
		internal.SetSubnetMask.enable:=	1;
	
	END_IF

	internal.SetSubnetMask.pDevice:=		ADR(INADeviceName);
	internal.SetSubnetMask.pSubnetMask:=	ADR(SubnetMask);
	internal.SetSubnetMask.Option:=			cfgOPTION_NON_VOLATILE;
	internal.SetSubnetMask();

	IF 	internal.SetSubnetMask.status = ERR_OK 
		THEN 
	
		internal.GetSubnetMask.enable:=	1;		
		internal.SetSubnetMask.enable:=	0;
		SubnetMask:=	'';
	
	END_IF


	// Gateway

	IF 	NOT (DefaultGateway = internal.Config.DefaultGateway) 
		AND NOT	internal.GetGateway.enable	
		THEN
	
		internal.SetGateway.enable:=	1;
	
	END_IF

	internal.SetGateway.pDevice:=	ADR(INADeviceName);
	internal.SetGateway.pGateway:=	ADR(DefaultGateway);
	internal.SetGateway.Option:=	cfgOPTION_NON_VOLATILE;
	internal.SetGateway();

	IF 	internal.SetGateway.status = ERR_OK 
		THEN
	
		internal.GetGateway.enable:=	1;	
		internal.SetGateway.enable:=	0;
		DefaultGateway:=	'';
	
	END_IF


	// Host Name

	IF 	NOT (HostName = internal.Config.HostName) 
		AND NOT  internal.GetHostName.enable
		THEN
	
		internal.SetHostName.enable:=	1;
	
	END_IF

	internal.SetHostName.pHostName:=	ADR(HostName);
	internal.SetHostName.Option:=		cfgOPTION_NON_VOLATILE;
	internal.SetHostName();

	IF 	internal.SetHostName.status = ERR_OK 
		THEN
	
		internal.GetHostName.enable:=	1;
		internal.SetHostName.enable:=	0;
		HostName:=	'';
	
	END_IF


	// INA Node

	IF 	NOT (INANode = internal.Config.INANode)
		AND NOT internal.GetInaNode.enable 
		THEN
	
		internal.SetInaNode.enable:=	1;
	
	END_IF

	internal.SetInaNode.pDevice:=	ADR(INADeviceName);
	internal.SetInaNode.InaNode:=	INANode;
	internal.SetInaNode.Option:=	cfgOPTION_NON_VOLATILE;
	internal.SetInaNode();

	IF 	internal.SetInaNode.status = ERR_OK 
		THEN 
	
		internal.GetInaNode.enable:=	1;		
		internal.SetInaNode.enable:=	0;
		INANode:=	0;
	
	END_IF		
	
	//---------------------------------------------------------------------------
	// Set Valid status
	//---------------------------------------------------------------------------


	// If all inputs are equal to internals, then set Valid
	// Otherwise, reset

	IF		(INADeviceName 	= internal.Config.INADeviceName)
		AND	(IPMode 		= internal.Config.IPMode)
		AND	(IPAddress 		= internal.Config.IPAddress)
		AND	(SubnetMask 	= internal.Config.SubnetMask)
		AND	(DefaultGateway = internal.Config.DefaultGateway)
		AND	(HostName 		= internal.Config.HostName)
		AND	(INANode 		= internal.Config.INANode)
		THEN
	
		Valid:=	1;

	ELSE

		Valid:=	0;

	END_IF


END_FUNCTION_BLOCK
