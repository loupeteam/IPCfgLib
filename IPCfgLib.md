![Automation Resources Group](http://automationresourcesgroup.com/images/arglogo254x54.png)

#IPCfgLib Library
The IPCfgLib library provides an interface for changing network configuration settings and connecting to Windows file devices.

Machines often need to be integrated into existing facility networks. This makes it difficult to select a network configuration that will be appropriate for every installation of a machine. Because of this, it is helpful to be able to configure network settings on a machine to machine basis. The IPCfgLib library provides a clean interface for changing network settings at runtime.

The IPCfgLib also supplies a clean interface to connect to a Windows network drive. Using Windows file sharing, a machine can read and write to a network drive in order to save and open recipes or configuration files. The WinShare function can be tied directly to the HMI for a user to enter usernames and passwords as well as parameters to configure what network drive to connect to.

#Usage
The IPCfgLib functionality can be integrated into any project using function blocks. For an example of how to use these in a project, please see the ARG Automation Studio Starter Project at [https://github.com/autresgrp/StarterProject](https://github.com/autresgrp/StarterProject).

##Initialization
To use the IPCfgLib functionality, **IPConfig** and **WinShare** function block instances must be declared.

##Cyclic Operation
The **IPConfig** and **WinShare** function blocks should be called in the CYCLIC routine of your program once every scan, unconditionally.

	IPConfig_0();
	WinShare_0();

These function blocks can then be used to configure a network interface and connect to a Windows network drive. The most common approach is to map the function block parameters directly to the HMI to allow a user to manually enter the correct settings.

#Reference

##IPConfig Function Block
The **IPConfig** function block provides an interface for changing network configuration settings.

###Inputs
* **INADeviceName** - The INA device name for the network interface to configure.
* **Refresh** - Refresh the function block with the current network settings for the interface.
* **ResetToDefaults** - This clears the configured network settings. After the next restart, the network settings will be restored to the default values configured in the Automation Studio project.

###Input/Outputs
The network settings exist as input/output parameters in the function block. If the value of a setting is changed, then that value will be set on the interface. If a **Refresh** command is issued or the **INADeviceName** input changes, then the values will be populated with the current settings for the interface.

* **IPMode** - Mode for obtaining an IP address. Possible values are cfgCONFIGMODE_MANUALLY (0) to set the IP address manually and cfgCONFIGMODE_DHCPCLIENT (1) to obtain an IP address from a DHCP server.
* **IPAddress** - IP address for the interface.
* **SubnetMask** - Subnet mask for the interface.
* **DefaultGateway** - Default gateway for the interface.
* **HostName** - Host name for the interface.
* **INANode** - INA node number for the interface.

###Outputs
* **Valid** - Set to 1 if the function block input/output values accurately reflect the current network settings.

##WinShare Function Block
The **WinShare** function block provides an interface for connecting to a Windows network drive.

###Inputs
* **Enable** - Enable the function block.
* **FileDevice** - File device name to be used in subsequent file IO operations (FileOpen, FileRead, etc.).
* **IPAddress** - IP address of the Windows computer to connect to.
* **ShareName** - Name of the Windows share to connect to.
* **UserName** - Windows username to use to sign in to the share.
* **Password** - Windows password to use to sign in to the share.

###Outputs
* **Status** - The status of the internal function blocks.