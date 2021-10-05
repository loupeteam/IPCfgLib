(********************************************************************
 * COPYRIGHT -- Automation Resources Group
 ********************************************************************
 * Program:
 * File: WinShare.st
 * Author: buchananw, Josh Polansky, David Blackburn
 * Created: May 12, 2010
 ********************************************************************
 * Implementation of library IPCfgLib
 ********************************************************************) 

 
FUNCTION_BLOCK WinShare

	
(*

    This function block implements a link to a windows network drive
    
    Parameters:
		FileDevice - Name of the file device to link. This is used for subsequent file IO operations (FileOpen, FileRead, etc.).
		IPAddress - IP address of the server
		ShareName - CIFS directory on the remote computer which should be mounted
		UserName - User name on the server
		Password - Password of the user on the server
        
    Returns:
        Status - Error code (0 = no error)
        
*)


	(* If IP address changes and we already connected to a server, disconnect *)
	
	IF(		(intipAddress <> IPAddress)
		AND	(DevUnlink_0.handle <> 0)
		)THEN

		intipAddress:=			IPAddress;	
		DevUnlink_0.enable:=	1;					

	END_IF
		
	DevUnlink_0();
	
	
	(* Don't try to link while unlinking *)
	
	IF (DevUnlink_0.status <> ERR_FUB_BUSY ) THEN
	
		DevUnlink_0.enable:=	0;
	
	ELSE
	
		Enable:=1;		
		RETURN;
	
	END_IF
	
	
    IF (Enable <> TRUE) THEN

        Status := 65534;

    END_IF
    
	
	(* Check for invalid inputs *)
	
    IF(		(FileDevice = '')
		OR	(IPAddress = '')
		OR	(ShareName = '')
		OR	(UserName = '')
		OR	(Password = '')
		)THEN

        Status:= 1;
        RETURN;

    END_IF
    
	
    brsmemset(ADR(tempString), 0, SIZEOF(tempString));
    brsstrcat(ADR(tempString), ADR('/SIP='));
    brsstrcat(ADR(tempString), ADR(IPAddress));
    brsstrcat(ADR(tempString), ADR(' /PROTOCOL=cifs /SHARE='));
    brsstrcat(ADR(tempString), ADR(ShareName));
    brsstrcat(ADR(tempString), ADR(' /USER='));
    brsstrcat(ADR(tempString), ADR(UserName));
    brsstrcat(ADR(tempString), ADR(' /PASSWORD='));
    brsstrcat(ADR(tempString), ADR(Password));
    
    DevLink_0.enable := Enable;
    DevLink_0.pDevice := ADR(FileDevice);
    DevLink_0.pParam := ADR(tempString);
    DevLink_0();
	
	
    IF (DevLink_0.status = fiERR_DEVICE_ALREADY_EXIST OR DevLink_0.status = 0) THEN
    
	    Status:=	0;
		Enable:=	0;
		DevUnlink_0.handle:=	DevLink_0.handle;
		intipAddress:=			IPAddress;
    
	ELSE
    
	    Status:=	DevLink_0.status;
    
	END_IF
	
	
END_FUNCTION_BLOCK
