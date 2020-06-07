# Documentation

**WARNING** :

This documentation is still heavily in `Work In Progress` status.

Latest `VControl` binaries are officially distributed from here :

https://www.apollo-accelerators.com/wiki/doku.php/saga:updates

Latest `Vampire Cores` are officially distributed from here :

https://www.apollo-accelerators.com/wiki/doku.php/vampire:accelerator_core_updates


# Supported Commands

Below are all the supported commands.

```HELP/S            This help
DE=DETECT/S       Return TRUE if AC68080 is detected
BO=BOARD/S        Output Board Informations
BI=BOARDID/S      Output Board Identifier
BN=BOARDNAME/S    Output Board Short Name
SN=BOARDSERIAL/S  Output Board Serial Number
CO=CORE/S         Output Core Revision String
CR=COREREV/S      Output Core Revision Number
CP=CPU/S          Output CPU informations
HZ=HERTZ/S        Output CPU Frequency (Hertz)
ML=MEMLIST/S      Output Memory list
MO=MODULES/S      Output Modules list
SE=SETENV/S       Create Environment Variables
AF=ATTNFLAGS/S    Change the AttnFlags (Force 080's)
AK=AKIKO/S        Change the GfxBase->ChunkyToPlanarPtr()
DP=DPMS/N         Change the DPMS mode. 0=Off, 1=On
FP=FPU/N          Change the FPU mode. 0=Off, 1=On
ID=IDESPEED/N     Change the IDE speed. 0=Slow, 1=Fast, 2=Faster, 3=Fastest
SD=SDCLOCKDIV/N   Change the SDPort Clock Divider. 0=Fastest, 255=Slowest
SS=SUPERSCALAR/N  Change the SuperScalar mode. 0=Off, 1=On
TU=TURTLE/N       Change the Turtle mode. 0=Off, 1=On
VB=VBRMOVE/N      Change the VBR location. 0=ChipRAM, 1=FastRAM
MR=MAPROM         Map a ROM file
```


# VControl CORE

SYNOPSIS:
This command reads the Vampire Core Revision String from its internal Flash chip.

INPUT :
* None

OUTPUT :
* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.


WARNING:

The `Core Revision String` is only present in the official AmigaOS Flash Binary cores provided by the APOLLO-Team

```
C:VControl CORE
Vampire 1200 V2 Apollo rev 7389B x12 (Gold 2.12)
>
```


# VControl SETENV

SYNOPSIS:
This command will creates the `VControl Environment Variables` into ENV:

INPUT :
* None

OUTPUT :
* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

Variable Name | Description
------------ | -------------
$VCoreRev | Core Revision Number (eg. 7589)
$VCoreFreq | Core CPU Frequency (eg. 78 MHz)
$VCoreMult | Core CPU Multiplier (eg. x11)
$VBoardID | Board Identifier model (eg. 6)
$VBoardName | Board Short Name (eg. V1200)

Below are some examples of how to use those variables.

```
C:VControl SE >NIL:

IF NOT WARN

	ECHO $VBoardName

	IF $VBoardID EQ 6
		ECHO "Enjoy your Vampire V1200"
	ENDIF

	IF $VCoreRev NOT GE 7390
		ECHO "Core is out dated, please download latest"
	ELSE
		ECHO "Core is up to date"
	ENDIF

ENDIF
```

```
IF $VBoardID EQ 0
	ECHO "Vampire NOT detected"
ELSE
	ECHO "Vampire detected"
ENDIF
```

```
IF $VBoardID GT 0
	ECHO "Vampire detected"
ELSE
	ECHO "Vampire NOT detected"
ENDIF
```


# VControl VBRMOVE 0/1

SYNOPSIS:
This command change the `Vector Base Register` location.
It is compatible with VBRControl http://aminet.net/package/util/sys/vbrcontrol

INPUT :
* VBRMOVE=0 : Chip RAM
* VBRMOVE=1 : Fast RAM

OUTPUT :
* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

```
C:VControl VBRMOVE 0 ; Relocate the VBR in CHIP memory (ADDRESS: 0x00000000)
C:VControl CPU ; Check the effect of the previous command. See VBR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (2p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)

```

```
C:VControl VBRMOVE 1 ; Relocate the VBR in FAST memory (ADDRESS: NON 0x00000000)
C:VControl CPU ; Check the effect of the previous command. See VBR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (2p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x088599C8 (Vector base is located in FAST Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)

```


# VControl MAPROM

SYNOPSIS:
This command map a 256KB or 512KB or 1MB ROM file and reboot the system.

INPUT :
* A valid ROM file

OUTPUT :
* Reboot the system

```
C:VControl MAPROM=C:Diag.ROM
```
