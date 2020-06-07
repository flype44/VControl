# Documentation

(C) Copyright 2016-2020 APOLLO-Team

The purpose of `VControl` is to bring some valuable informations and controls over the `Vampire` boards.

This article describe all the commands provided in the `VControl` program.

It always refers to the latest version. Take care using latest version in your scripts.

**WARNING** :

This documentation is still heavily in `Work In Progress` status.


# Releases

Latest `VControl` binaries are officially distributed from [here](https://www.apollo-accelerators.com/wiki/doku.php/saga:updates). 

Latest `Vampire` cores are officially distributed from [here](https://www.apollo-accelerators.com/wiki/doku.php/vampire:accelerator_core_updates). 


# Commands

Below are all the supported commands.

* **/S** means **Switch**. Expect NO argument.
* **/N** means **Number**. Expect a valid number as argument.

Command | Description
------------ | -------------
[HELP/S](#commands) | This help
[DE=DETECT/S](#vcontrol-detect) | Return AC68080 detection is $RC
[BO=BOARD/S](#vcontrol-board) | Output Board Informations
[BI=BOARDID/S](#vcontrol-boardid) | Output Board Identifier
[BN=BOARDNAME/S](#vcontrol-boardname) | Output Board Name
[SN=BOARDSERIAL/S](#vcontrol-boardserial) | Output Board Serial Number
[CO=CORE/S](#vcontrol-core) | Output Core Revision String
[CR=COREREV/S](#vcontrol-corerev) | Output Core Revision Number
[CP=CPU/S](#vcontrol-cpu) | Output CPU informations
[HZ=HERTZ/S](#vcontrol-hertz) | Output CPU Frequency (Hertz)
[ML=MEMLIST/S](#vcontrol-memlist) | Output Memory list
[MO=MODULES/S](#vcontrol-modules) | Output Modules list
[SE=SETENV/S](#vcontrol-setenv) | Create Environment Variables
[AF=ATTNFLAGS/S](#vcontrol-attnflags) | Change the AttnFlags (Force 080's)
[AK=AKIKO/S](#vcontrol-akiko) | Change the GfxBase->ChunkyToPlanarPtr()
[DP=DPMS/N](#vcontrol-dpms) | Change the DPMS mode. 0=Off, 1=On
[FP=FPU/N](#vcontrol-fpu) | Change the FPU mode. 0=Off, 1=On
[ID=IDESPEED/N](#vcontrol-idespeed) | Change the IDE speed. 0=Slow, 1=Fast, 2=Faster, 3=Fastest
[SD=SDCLOCKDIV/N](#vcontrol-sdclockdiv) | Change the SDPort Clock Divider. 0=Fastest, 255=Slowest
[SS=SUPERSCALAR/N](#vcontrol-superscalar) | Change the SuperScalar mode. 0=Off, 1=On
[TU=TURTLE/N](#vcontrol-turtle) | Change the Turtle mode. 0=Off, 1=On
[VB=VBRMOVE/N](#vcontrol-vbrmove) | Change the VBR location. 0=ChipRAM, 1=FastRAM
[MR=MAPROM](#vcontrol-maprom) | Map a ROM file

**NOTE :**

For more informations about the `Amiga DOS command line arguments`, 

Please refer to the official documentations :

[AmigaDOS: TEMPLATES](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Command_Reference#Template)

[AmigaDOS: IF/ELSE](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Command_Reference#IF)

[AmigaDOS: SCRIPTS](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Using_Scripts)


**EXAMPLES :**

```
> C:VControl
> C:VControl ?
> C:VControl HELP
> VERSION C:VControl FULL
> 
```


# VControl DETECT

**SYNOPSIS :**

This command proceed a true `Apollo Core 68080` detection by checking the presence of the processor `PCR` register and the associated revision word (which should be `0x0440` for a 68080 CPU). As a consequence, this command does not rely on any Operating System prerequisites (such as the Exec->AttnFlags, or presence of some kickstart modules).

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if detected.
* Returns DOS WARN ($RC = 5) if not detected.

**EXAMPLES :**

```
> C:VControl DETECT
> Echo $RC
0
```

```
C:VControl DETECT
IF WARN
	ECHO "AC68080 NOT detected"
ELSE
	ECHO "AC68080 detected"
ENDIF
```


# VControl BOARD

**SYNOPSIS :**

This command collects and output informations about the Vampire Board.

**INPUT :**

* None

**OUTPUT :**

* Print out informations about the Vampire Board.

**EXAMPLES :**

```
C:VControl BOARD
Board informations :

Product-ID   : 6
Product-Name : Vampire V1200
Serial-Number: 0000000000000000-0
Designer     : Majsta
Manufaturer  : APOLLO-Team (C)

EClock Freq. : 7.09379 Hz (PAL)
VBlank Freq. : 50 Hz
Power  Freq. : 50 Hz

Video Chip   : AGA Lisa (4203)
Audio Chip   : Paula (8364 rev0)
Akiko Chip   : Not detected (0x0000)
Akiko C2P    : Uninitialized (0x00000000)

Chip Memory  :   2.0 MB
Fast Memory  : 126.5 MB
Slow Memory  : 512.0 KB
```


# VControl BOARDID

**SYNOPSIS :**

This command retrieve the Vampire `Board Identifier` model.

List of the Vampire `Board Identifiers` :

* `1` = V600
* `2` = V500
* `3` = V4 Accelerator
* `4` = V666
* `5` = V4 StandAlone
* `6` = V1200

**INPUT :**

* None

**OUTPUT :**

* $RC = Vampire `Board Identifier` model (numeric).

**EXAMPLES :**

```
C:VControl BOARDID
> Echo $RC
6
```

```
C:VControl BOARDID
IF $RC EQ 6
	ECHO "You have a V1200"
ENDIF
```

```
C:VControl BOARDID >ENV:IDENTIFIER
IF $IDENTIFIER EQ 6
	ECHO "You have a V1200"
ENDIF
```


# VControl BOARDNAME

**SYNOPSIS :**

This command ouput the Vampire `Board Short Name` based on the `Board Identifier` model.

**INPUT :**

* None

**OUTPUT :**

* Print out the Vampire Board short name

**EXAMPLES :**

```
> C:VControl BOARDNAME
V1200
>
```

```
> C:VControl BOARDNAME >ENV:NAME
> Echo $NAME
V1200
>
```


# VControl BOARDSERIAL

**SYNOPSIS :**

This command retrieve the Vampire Board `Serial Number`.

**INPUT :**

* None

**OUTPUT :**

* Print out the Vampire Board `Serial Number`.

**NOTE :**

Implemented and works for `V500`, `V600`, `V1200`.

Implemented and **NOT** works for `V4`, for now.

**EXAMPLES :**

```
> C:VControl BOARDSERIAL
0x26F0A280C118B206-4
>
```

```
> C:VControl BOARDSERIAL >ENV:SERIAL
> Echo $SERIAL
0x26F0A280C118B206-4
>
```


# VControl CORE

**SYNOPSIS :**

This command reads the Vampire `Core Revision String` from its internal Flash chip.

The `Core Revision String` is only present in the official AmigaOS Flash Binary cores provided by the APOLLO-Team.

This means this feature can **NOT** work on cores provided in the `Quartus .JIC` forms.

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**EXAMPLES :**

```
> C:VControl CORE
Vampire 1200 V2 Apollo rev 7389B x12 (Gold 2.12)
> 
```


# VControl COREREV

**SYNOPSIS :**

This command parse the `Revision Number` contained into the Vampire `Core Revision String`.

The `Core Revision String` is only present in the official AmigaOS Flash Binary cores provided by the APOLLO-Team.

This means this feature can **NOT** work on cores provided in the `Quartus .JIC` forms.

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**EXAMPLES :**

```
> C:VControl COREREV
7389
> 
```

```
C:VControl COREREV >ENV:REVISION
IF NOT WARN
	IF $REVISION NOT GE 7389
		ECHO "Core is NOT up to date"
	ELSE
		ECHO "Core is up to date"
	ENDIF
ENDIF
```

# VControl CPU

**SYNOPSIS :**

This command collects and output informations about the Apollo Core 68080 processor, such as the CPU frequency, the FPU presence, the registers status, and more.

Some of them are controllable from `VControl`, eg. FPU, SuperScalar, Turtle, VectorBase.

**INPUT :**

* None

**OUTPUT :**

* Print out informations about the Apollo Core 68080 processor.

**DETAILS :**

```
* CPU:  Model @ Frequency (Multiplier) (Pipe Count)
* FPU:  Detection and Status
* PCR:  Processor Control Register
	* ID:  Processor Identifier
	* REV: Processor Revision
	* DFP: Disable Floating Point bit
	* ESS: Enable SuperScalar bit
* VBR:  Vector Base Register
* CACR: Cache Control Register
	* InstCache: Instruction Cache bit
	* DataCache: Data Cache bit
* ATTN: Exec -> AttnFlags bits
```

**EXAMPLES :**

```
> C:VControl CPU
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (1p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
```


# VControl HERTZ

**SYNOPSIS :**

This command determines the frequency (in MHz) of the `Apollo Core 68080` processor.

On contrary to the usual Hardware method, this command use a `Software method` to determine the frequency.

It calculate the real number of processor cycles occured in 1 second, using the AC68080 `Clock-Cycle Register`.

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.
* A string representing the frequency and multiplier of the processor.

**NOTE :**

This command takes 1 second to execute (blocking), on purpose.

**EXAMPLES :**

```
> C:VControl HERTZ
AC68080 @ 85 MHz (x12)
>
```


# VControl MEMLIST

**SYNOPSIS :**

Description.

**INPUT :**

* None

**OUTPUT :**

* None

**EXAMPLES :**

```
...
```


# VControl MODULES

**SYNOPSIS :**

Description.

**INPUT :**

* None

**OUTPUT :**

* None

**EXAMPLES :**

```
...
```


# VControl SETENV

**SYNOPSIS :**

This command will creates the `VControl Environment Variables` into `ENV:`

As a consequency, `ENV:` assign **MUST** be initialized before executing this command.

Those variables are intended to make life easier for scripting usages.

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**RESULTS :**

Variable | Description | Example
------------ | ------------ | ------------
$VCoreRev | Core Revision Number | 7589
$VCoreFreq | Core CPU Frequency | 85
$VCoreMult | Core CPU Multiplier | 12
$VBoardID | Board Identifier model | 6
$VBoardName | Board Short Name | V1200

**NOTE :**

The variables are created **ONLY** if a Vampire is detected.

**EXAMPLES :**

```
> C:VControl SETENV
> Echo AC68080 @ $VCoreFreq MHz (x$VCoreMult)
AC68080 @ 85 MHz (x12)
> 
```

```
C:VControl SETENV >NIL:

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

```
IF EXISTS ENV:VBoardID
	ECHO "Vampire detected"
ELSE
	ECHO "Vampire NOT detected"
ENDIF
```

```
IF NOT EXISTS ENV:VBoardID
	ECHO "Vampire NOT detected"
ELSE
	ECHO "Vampire detected"
ENDIF
```


# VControl ATTNFLAGS

**SYNOPSIS :**

This command change the Operating System `Exec -> AttnFlags` in order to forces the usual AC68080's.

It can be handy when MapROM'ing some ROM which do not initialize the AC68080 Exec flags.

Those flags are forced :

* AFF_68010
* AFF_68020
* AFF_68030
* AFF_68040
* AFF_68080

(!) This function is reserved for testings and may change in future (!)

**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0).

**EXAMPLES :**

```
> C:VControl ATTNFLAGS
AttnFlags : 0x847f
>
```


# VControl AKIKO

**SYNOPSIS :**

This command check the presence of the `CD32 Akiko Chip`, check if the graphics.library is `V40+`, and update the `GfxBase -> ChunkyToPlanarPtr` address if necessary.

This may be needed when the graphics.library fail to detect the Akiko chip during the boot process.

The graphics.library `WriteChunkyPixels()` function can benefits of such hardware, when detected and enabled.

More information [here](http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node033C.html).


**INPUT :**

* None

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed (Akiko Chip or V40 not found).

**NOTE :**

Theorically, it's only aiming `AGA` Amiga machines.

Currentely compatible with the `Vampire V4` model.

Planned for the `Vampire V1200` in future core.

**EXAMPLES :**

```
> C:VControl AKIKO
V40+ GfxBase->ChunkyToPlanarPtr() initialized.
> 
```

```
> C:VControl AKIKO
V40+ or Akiko not detected
> 
```


# VControl DPMS

**SYNOPSIS :**

This command tells the Graphics Driver to turn On/Off the monitor or TV that is connected to the Vampire Digital Video Out.

It changes the VESA `Display Power Management Signaling` (DPMS) level, through the CGX API -> CVideoCtrlTagList().

**INPUT :**

* `DPMS=0` : Turn ON the display.
* `DPMS=1` : Turn OFF the display.

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed (No compatible CGX API).

**NOTE :**

The Vampire P96 GFX Driver support the DPMS signals.

Recommended tool : [DPMSManager](http://aminet.net/package/util/blank/DPMSManager) for energy-saving.

However, one may need to disable the display MANUALLY for various reasons, such as benchmarkings.

**EXAMPLES :**

```
C:VControl DPMS 1 ; Turn OFF the display
C:MyBenchmarkTool
C:VControl DPMS 0 ; Turn ON the display
```

# VControl FPU

**SYNOPSIS :**

Description.

**INPUT :**

* None

**OUTPUT :**

* None

**EXAMPLES :**

```
...
```


# VControl IDESPEED

**SYNOPSIS :**

This command change the Vampire `FastIDE` mode for faster-than-legacy `IDE` devices reads.

NO WARRANTY IS PROVIDED. USE AT YOUR OWN RISK.

**INPUT :**

* `IDESPEED=0` : PIO Mode 0 → Very old hard disks and CD/DVD drives. Default at boot.
* `IDESPEED=1` : PIO Mode 4 → Most hard disks and CD/DVD drives, and for very old CompactFlash cards.
* `IDESPEED=2` : PIO Mode 5 → Most CompactFlash cards.
* `IDESPEED=3` : PIO Mode 6 → Fast CompactFlash cards.

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**NOTE :**

This command applies only on compatible Vampire board, with an embedded `FastIDE` slot.

It should be added at the beginning of `S:Startup-Sequence` so that `FastIDE` is enabled on every boot.

**EXAMPLES :**

```
> C:VControl IDESPEED=2
> 
```


# VControl SDCLOCKSPEED

**SYNOPSIS :**

Description.

**INPUT :**

* None

**OUTPUT :**

* None

**EXAMPLES :**

```
...
```


# VControl SUPERSCALAR

**SYNOPSIS :**

This command enable or disable the so-called Apollo Core `SUPERSCALAR` mode (Default is Enabled).

SuperScalar is processor feature which allow to `execute 2 instructions` per fetch, through a `2nd pipe`.

When enabled, the processor works faster, whenever appliable, and even more with programs compiled for (When compiled for MC68060).

**INPUT :**

* `SUPERSCALAR=0` : Disable the processor SUPERSCALAR mode (1 pipe mode).
* `SUPERSCALAR=1` : Enable the processor SUPERSCALAR mode (2 pipes mode).

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**EXAMPLES :**

```
> C:VControl SUPERSCALAR 0 ; Disable SuperScalar.
SuperScalar: Disabled.
> C:VControl CPU ; Check the effect of the previous command. See PCR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (1p)
FPU:  Is working.
PCR:  0x04400000 (ID: 0440) (REV: 0) (DFP: Off) (ESS: Off)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```

```
> C:VControl SUPERSCALAR 1 ; Enable SuperScalar.
SuperScalar: Enabled.
> C:VControl CPU ; Check the effect of the previous command. See PCR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (1p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```


# VControl TURTLE

**SYNOPSIS :**

This command enable or disable the so-called Apollo Core `TURTLE` mode.

This feature intends to **HEAVILY** slowdown the processor execution in order to approximate the `MC68000` / `MC68020` speed.

It eventually helps compatibility when launching old Amiga demos and games.

**INPUT :**

* `TURTLE=0` : Disable the TURTLE slow mode.
* `TURTLE=1` : Enable the TURTLE slow mode.

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**EXAMPLES :**

```
> C:VControl TURTLE 0
Turtle: Disabled.
> 
```

```
> C:VControl TURTLE 1
Turtle: Enabled.
> 
```

```
> C:VControl TURTLE 1 >NIL:
> 
```


# VControl VBRMOVE

**SYNOPSIS :**

This command change the processor `Vector Base Register` location.

The processor vectors will be moved to a new location, either in CHIP memory (VBRMOVE=0) or in FAST memory (VBRMOVE=1).

When the processor vectors are moved to FAST memory, it is supposed to increase the system speed, a little.

**INPUT :**

* `VBRMOVE=0` : Chip RAM
* `VBRMOVE=1` : Fast RAM

**OUTPUT :**

* Returns DOS OK ($RC = 0) if successful.
* Returns DOS WARN ($RC = 5) if failed.

**NOTE :**

This command is compatible with [VBRControl](http://aminet.net/package/util/sys/vbrcontrol).

**EXAMPLES :**

```
> C:VControl VBRMOVE 0 ; Relocate the VBR in CHIP memory.
> C:VControl CPU ; Check the effect of the previous command. See VBR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (2p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```

```
> C:VControl VBRMOVE 1 ; Relocate the VBR in FAST memory.
> C:VControl CPU ; Check the effect of the previous command. See VBR line.
Processor informations :

CPU:  AC68080 @ 85 MHz (x12) (2p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x088599C8 (Vector base is located in FAST Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```


# VControl MAPROM

**SYNOPSIS :**

This command map a `256KB` or `512KB` or `1MB` valid ROM file and REBOOT the system.

It does a RAW maprom, the input file content remains unchecked, untouched and mapped as is.

**INPUT :**

* A valid ROM file

**OUTPUT :**

* Reboot the system if successful.
* Returns DOS WARN ($RC = 5) if failed.

**NOTE :**

* The mapped ROM will survive from a `WARM REBOOT`.

* The mapped ROM will NOT survive from a `POWER OFF`.

* Shutdown the system if the mapped ROM gives troubles.

**EXAMPLES :**

```
> C:VControl MAPROM=C:Diag.ROM
> 
```
