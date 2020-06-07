# Documentation

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


# Examples

Below are concrete examples where/when/how to use VControl.

_WARNING_: This documentation is still Work In Progress.


# HOW TO : VControl SETENV

This command will creates the Environment Variables into ENV:
If succesful, it returns OK ($RC = 0). Else WARN ($RC = 5).

* $VCoreRev
* $VCoreFreq
* $VCoreMult
* $VBoardID
* $VBoardName

Below is an example of how to use `VControl SETENV`.

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
