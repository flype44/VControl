# VControl

> (C) Copyright 2016-2020 APOLLO-Team

Written and maintained by `flype`, APOLLO-Team member.

The purpose of `VControl` is to bring valuable information and control over the `Vampire` boards.

![Vampire Logo](V_LOGO.png)


# Documentation

This article describes all the commands provided in the `VControl` program.

It always refers to the latest version. Take care to use latest version in your scripts.

This documentation is written by the `VControl` author, with the great help from `MuadDib`.


# License

`VControl` is licensed under the [Mozilla Public License 2.0](LICENSE)

Permissions of this weak copyleft license are conditioned on making available source code of licensed files and modifications of those files under the same license (or in certain cases, one of the GNU licenses). Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. However, a larger work using the licensed work may be distributed under different terms and without source code for files added in the larger work.


# Releases

Latest `VControl` binaries are officially distributed from [here](https://www.apollo-accelerators.com/wiki/doku.php/saga:updates). 

Latest `Vampire` cores are officially distributed from [here](https://www.apollo-accelerators.com/wiki/doku.php/start#core_and_software_updates). 


# Commands

Below are all the supported commands.

* `/S` means `Switch`. Expect NO argument.
* `/N` means `Number`. Expect a valid number as argument.

Command | Description
------------ | -------------
[HELP/S](#commands) | This help
[DE=DETECT/S](#vcontrol-detect) | Return AC68080 detection in $RC
[BO=BOARD/S](#vcontrol-board) | Output Board Information
[BI=BOARDID/S](#vcontrol-boardid) | Output Board Identifier
[BN=BOARDNAME/S](#vcontrol-boardname) | Output Board Name
[SN=BOARDSERIAL/S](#vcontrol-boardserial) | Output Board Serial Number
[CO=CORE/S](#vcontrol-core) | Output Core Revision String
[CR=COREREV/S](#vcontrol-corerev) | Output Core Revision Number
[CP=CPU/S](#vcontrol-cpu) | Output CPU information
[HZ=CPUHERTZ/S](#vcontrol-cpuhertz) | Output CPU Frequency (Hertz)
[ML=MEMLIST/S](#vcontrol-memlist) | Output Memory list
[MO=MODULES/S](#vcontrol-modules) | Output Modules list
[CD=CONFIGDEV/S](#vcontrol-configdev) | Output ConfigDev list
[SE=SETENV/S](#vcontrol-setenv) | Create Environment Variables
[AF=ATTNFLAGS/S](#vcontrol-attnflags) | Change the AttnFlags (Force 080's flags)
[AK=AKIKO/S](#vcontrol-akiko) | Initialize the Akiko C2P routine
[DP=DPMS/N](#vcontrol-dpms) | Change the DPMS mode. 0=Off, 1=On
[FP=FPU/N](#vcontrol-fpu) | Change the FPU mode. 0=Off, 1=On
[ID=IDESPEED/N](#vcontrol-idespeed) | Change the IDE speed. 0=Slow, 1=Fast, 2=Faster, 3=Fastest
[SD=SDCLOCKDIV/N](#vcontrol-sdclockdiv) | Change the SDPort Clock Divider. 0=Fastest, 255=Slowest
[SS=SUPERSCALAR/N](#vcontrol-superscalar) | Change the SuperScalar mode. 0=Off, 1=On
[TU=TURTLE/N](#vcontrol-turtle) | Change the Turtle mode. 0=Off, 1=On
[VB=VBRMOVE/N](#vcontrol-vbrmove) | Change the VBR location. 0=ChipRAM, 1=FastRAM
[MR=MAPROM](#vcontrol-maprom) | Map a ROM file

**NOTE :**

For more information about the `Amiga DOS` command line arguments and scripting, 

Please refer to the official documentation :

[AmigaDOS: Templates](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Command_Reference#Template)

[AmigaDOS: If/Else/Endif](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Command_Reference#IF)

[AmigaDOS: Using Scripts](https://wiki.amigaos.net/wiki/AmigaOS_Manual:_AmigaDOS_Using_Scripts)


**EXAMPLES :**

```
> C:VControl
> C:VControl ?
> C:VControl HELP
> VERSION C:VControl FULL
> 
```


# VControl AKIKO

**SYNOPSIS :**

This command initializes the `Akiko` Chunky To Planar routine.

It checks the presence of the `CD32 Akiko Chip`, checks if the graphics.library is `V40+`, and finally updates the `GfxBase -> ChunkyToPlanarPtr` address if necessary.

This may be needed when the graphics.library fails to detect the Akiko Chip during the boot process.

The graphics.library `WriteChunkyPixels()` function can take advantage of such hardware, when detected and enabled.

More information [here](http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node033C.html).

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed (Akiko Chip or V40 not found).

**NOTE :**

Theoretically, it's only aimed at `AGA` Amiga machines.

Currently compatible with the `Vampire V4` model.

Planned for the `Vampire V1200` in future core.

This command uses the following `CD32` chipset registers : `0xB80002` (ID) and `0xB80038` (C2P).

**EXAMPLES :**

```
> C:VControl AKIKO
V40+ GfxBase->ChunkyToPlanarPtr() initialized.
> 
```

```
> C:VControl AKIKO
V40+ or Akiko not detected.
> 
```


# VControl ATTNFLAGS

**SYNOPSIS :**

This command changes the Operating System `Exec -> AttnFlags` in order to force the usual 68080 ones.

It can be handy when MapROM'ing some ROM which does not initialize the AC68080 Exec flags.

These flags are forced :

* AFF_68010
* AFF_68020
* AFF_68030
* AFF_68040
* AFF_68080

(!) This function is experimental and may change in future (!)

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0).

**NOTE :**

For coders, the following values might not be declared in `exec/execbase.h`, here are the correct values :

```
#ifndef AFB_68060
#define AFB_68060 7
#define AFF_68060 (1 << AFB_68060)
#endif

#ifndef AFB_68080
#define AFB_68080 10
#define AFF_68080 (1 << AFB_68080)
#endif
```

More information [here](http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node009E.html).

**EXAMPLES :**

```
> C:VControl ATTNFLAGS
AttnFlags : 0x847f
> 
```


# VControl BOARD

**SYNOPSIS :**

This command collects and outputs information about the Vampire Board.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out information about the Vampire Board.

**NOTE :**

This command uses :

* Vampire `VREG_BOARD` (`0xdff3fc`) chipset register.
* Vampire `Serial Peripheral Interface` (SPI) private registers.
* AmigaHW `POTINP` (`0xdff016`) chipset register, for the Audio chip version.
* AmigaHW `DENISEID` (`0xdff07c`) chipset register, for the Video chip version.
* AmigaOS `Exec` functions for the available memory and frequency information.

**EXAMPLES :**

```
> C:VControl BOARD
Board information :

Product-ID   : 6
Product-Name : Vampire V1200
Serial-Number: 0000000000000000-0
Designer     : Majsta
Manufacturer : APOLLO-Team (C)

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
> 
```


# VControl BOARDID

**SYNOPSIS :**

This command retrieves the Vampire `Board Identifier` model.

List of the Vampire `Board Identifiers` :

* `0` : Unidentified
* `1` : V600
* `2` : V500
* `3` : V4 Accelerator
* `4` : V666
* `5` : V4 StandAlone
* `6` : V1200

**INPUT :**

* None

**OUTPUT :**

* Returns the Vampire `Board Identifier` ($RC).
* If `$RC` is `0`, it means no Vampire hardware detected.

**NOTE :**

This command uses the Vampire `VREG_BOARD` (`0xdff3fc`) chipset register.

**EXAMPLES :**

```
> C:VControl BOARDID
> Echo $RC
6
> 
```

```
C:VControl BOARDID
IF $RC EQ 2
	ECHO "You have a V500"
ENDIF
```

```
C:VControl BOARDID
IF $RC GT 0
	ECHO "Vampire board detected"
ELSE
	ECHO "Vampire board NOT detected"
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

This command ouputs the Vampire `Board Short Name` based on the `Board Identifier` model.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out the Vampire `Board Short Name`.

**NOTE :**

This command uses the Vampire `VREG_BOARD` (`0xdff3fc`) chipset register.

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

```
C:VControl BOARDNAME >ENV:NAME
IF NOT WARN
	ECHO $NAME
ENDIF
```


# VControl BOARDSERIAL

**SYNOPSIS :**

This command retrieves the Vampire `Board Serial Number`.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out the Vampire `Board Serial Number`.

**NOTE :**

Implemented and works for `V500`, `V600`, `V1200`.

Implemented and does **NOT** work for `V4`, for now.

This command uses some Vampire `Serial Peripheral Interface` (SPI) private registers.

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


# VControl CONFIGDEV

**SYNOPSIS :**

This command enumerates the `Expansion` devices, by using FindConfigDev().

It should never fail since Exec is always available.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0).

**NOTES :**

(!) This function is experimental and may change in future (!)

**EXAMPLES :**

```
> C:VControl CONFIGDEV
Expansion information:

Address    BoardAddr BoardSize Type Manufacturer Product Description
$00004020: $00dfe000   64.0 KB 0xc1 0x1398       0x06    Majsta @ Vampire V1200
>
```


# VControl CORE

**SYNOPSIS :**

This command reads the Vampire Core `Revision String` from its internal Flash chip.

The Core `Revision String` is only present in the official AmigaOS Flash Binary cores provided by the APOLLO-Team.

This means this feature can **NOT** work on cores provided in the `Altera Quartus .JIC` forms (when flashed with a `USB-Blaster` device).

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out the Core `Revision String`.

**NOTE :**

This command uses some Vampire `Serial Peripheral Interface` (SPI) private registers.

**EXAMPLES :**

```
> C:VControl CORE
Vampire 1200 V2 Apollo rev 7389B x12 (Gold 2.12)
> 
```


# VControl COREREV

**SYNOPSIS :**

This command parses the `Revision Number` found inside the Vampire Core `Revision String`.

The Core `Revision String` is only present in the official AmigaOS Flash Binary cores provided by the APOLLO-Team.

This means this feature can **NOT** work on cores provided in the `Quartus .JIC` forms (when flashed with a `USB-Blaster` device).

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out the Core `Revision Number`.

**NOTE :**

This command uses some Vampire `Serial Peripheral Interface` (SPI) private registers.

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

This command collects and outputs information about the Apollo Core `68080` processor, such as the CPU frequency, the FPU presence, the registers status, and more.

Some of them are controllable from `VControl`, eg. FPU, SuperScalar, Turtle, VectorBase.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out information about the Apollo Core `68080` processor.

**NOTE :**

This command uses :

* AmigaOS `Exec -> AttnFlags`.
* Vampire `VREG_BOARD` chipset register.
* Motorola™ `Vector Base Register` (VBR) register.
* Motorola™ `Cache Control Register` (CACR) register.
* Motorola™ `Processor Configuration Register` (PCR) register.

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
Processor information :

CPU:  AC68080 @ 85 MHz (x12) (1p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x00000000 (Vector base is located in CHIP Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```


# VControl CPUHERTZ

**SYNOPSIS :**

This command determines the frequency (in MHz) of the Apollo Core `68080` processor.

Contrary to the usual `Hardware` method (eg. `VREG_BOARD` register), this command uses a `Software` method to determine the frequency.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.
* Print out a string representing the `frequency` and `multiplier` of the processor.

**NOTE :**

This command takes 1 second to execute (blocking), on purpose.

It calculates the real number of processor cycles that occurred in 1 second.

This command uses the `Clock-Cycle Register` MOVEC register of the Apollo Core `68080` processor.

**EXAMPLES :**

```
> C:VControl CPUHERTZ
AC68080 @ 85 MHz (x12)
> 
```


# VControl DETECT

**SYNOPSIS :**

This command performs a true `Apollo Core 68080` detection.

It checks the presence of the processor `PCR` register and the associated processor identifier word (which should be `0x0440` for a 68080 CPU).

It does not rely on any Operating System prerequisites (such as the Exec->AttnFlags, or the presence of some kickstart modules).

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if detected.
* Returns `WARN` ($RC = 5) if not detected.

**NOTE :**

This command uses the Motorola™ `Processor Configuration Register` (PCR) register.

**EXAMPLES :**

```
> C:VControl DETECT
> Echo $RC
0
> 
```

```
C:VControl DETECT
IF WARN
	ECHO "AC68080 NOT detected"
ELSE
	ECHO "AC68080 detected"
ENDIF
```


# VControl DPMS

**SYNOPSIS :**

This command tells the Graphics Driver to turn On/Off the monitor or TV that is connected to the Vampire Digital Video Out.

It changes the VESA `Display Power Management Signaling` (DPMS) level by calling the CGX API -> CVideoCtrlTagList().

**INPUT :**

* `DPMS=0` : Turn ON the display.
* `DPMS=1` : Turn OFF the display.

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed (No compatible CGX API).

**NOTE :**

The Vampire P96 Graphics Driver supports the `DPMS` signals.

The `Stand-by` and `Suspend` states are not supported.

Recommended tool : [DPMSManager](http://aminet.net/package/util/blank/DPMSManager) for energy-saving.

However, one may need to disable the display MANUALLY for various reasons, such as benchmarking.

**EXAMPLES :**

```
C:VControl DPMS 1 ; Turn OFF the display
C:MyBenchmarkTool
C:VControl DPMS 0 ; Turn ON the display
```


# VControl FPU

**SYNOPSIS :**

This command switchs the `FPU` On/Off by using the dedicated API from `vampiresupport.resource`.

**INPUT :**

* `FPU=0` : Switch OFF the FPU.
* `FPU=1` : Switch ON the FPU.

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed (`vampiresupport.resource` not found).

**NOTE :**

This setting is reset to `1` after a reboot.

This command uses the Motorola™ `Processor Configuration Register` (PCR) register, Bit `Disable Floating Point` (DFP).

In essence, the FPU Off needs to be done as early as possible in the `S:Startup-Sequence`, preferably before the `SetPatch` command.

When executed from the Workbench, various malfunctions may/will happen.

For instance, the OS math libraries may/will not work properly.

**EXAMPLES :**

```
;
C:VControl FPU=0
C:SetPatch
;
```


# VControl IDESPEED

**SYNOPSIS :**

> NO WARRANTY IS PROVIDED. USE AT YOUR OWN RISK.

This command changes the Vampire `FastIDE` mode for faster-than-legacy `IDE` device reads.

It applies only to compatible Vampire boards, with an embedded `FastIDE` slot (eg. `V500`, `V1200`, `V4`).

**INPUT :**

* `IDESPEED=0` : PIO Mode 0 → Very old hard disks and CD/DVD drives. Default at boot.
* `IDESPEED=1` : PIO Mode 4 → Most hard disks and CD/DVD drives, and very old CompactFlash cards.
* `IDESPEED=2` : PIO Mode 5 → Most CompactFlash cards.
* `IDESPEED=3` : PIO Mode 6 → Fast CompactFlash cards.

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

This setting is reset to `0` after every reboot.

This command uses the Vampire `VREG_FASTIDE` (`0xdd1020`) chipset register.

It is possible that your storage device (along with any intermediate adapters and cables you might have) supports a speed that is higher than the level recommended above. To explore this possibility, you can try setting `IDESPEED` to a higher level and thoroughly testing some data transfer operations. If you do not get any data corruption, you can keep `IDESPEED` at that higher level.

If you attach multiple devices to a single IDE cable, the slowest device will dictate the maximum speed on this IDE interface. For example, if you have connected a CompactFlash card that supports PIO mode 6, together with a hard disk which only supports PIO mode 4, then you would need to limit yourself to `IDESPEED=1`.

To enable the desired `FastIDE` mode on every boot, you should add the appropriate `VControl IDESPEED` command towards the beginning of your `S:Startup-Sequence`.

**EXAMPLES :**

```
> C:VControl IDESPEED=2
FastIDE mode = 0x8000 (Faster).
> 
```


# VControl MAPROM

**SYNOPSIS :**

This command maps a `256KB` or `512KB` or `1MB` valid ROM file and REBOOTs the system.

It does a RAW maprom, the input file content remains unchecked, unmodified and mapped as is.

**INPUT :**

* A valid ROM file

**OUTPUT :**

* Reboots the system if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

The ROM file passed in argument will be copied to the following locations :

* 1st 512KB at address `$00E00000` to `$00E7FFFF`.
* 2nd 512KB at address `$00F80000` to `$00FFFFFF`.

A check is performed to verify if the provided ROM file is already installed in memory.

This check prevents infinite reboots if `VControl MAPROM` is installed in the `S:Startup-Sequence`.

The mapped ROM will survive a `WARM REBOOT`.

The mapped ROM will NOT survive a `POWER OFF`.

In case of trouble, try `CTRL` + `A` + `A`, it may help start the new ROM.

A MAPROM can **NEVER** brick the machine, a `POWER OFF` will **ALWAYS** restore the ROM installed in the system.

This command uses the Vampire `VREG_MAPROM` (`0xdff3fe`) chipset register.

**EXAMPLES :**

```
> C:VControl MAPROM=C:Diag.ROM
> 
```


# VControl MEMLIST

**SYNOPSIS :**

This command displays all the memory nodes found inside the AmigaOS `Exec -> MemList`.

It gives quite similar information to `C:ShowConfig`.

It should never fail since Exec is always available.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0).

**EXAMPLES :**

V1200, from AmigaOS :
```
> C:VControl MEMLIST
Memory information:

Address    Name              Pri Lower     Upper     Attrs 
$08000000: expansion memory   40 $08000020 $0fdfffff $0505 (126.0 MB)
$00c00000: memory             -5 $00c00020 $00c7ffff $0705 (511.9 KB)
$00004000: chip memory       -10 $00004020 $001fffff $0703 (  2.0 MB)
> 
```

V4, from AmigaOS :
```
Address    Name              Pri Lower     Upper     Attrs 
$01000000: VampireFastMem     64 $01000020 $1fffffff $0505 (496.0 MB)
$00c00000: memory             -5 $00c00020 $00d7ffff $0705 (  1.5 MB)
$00004000: chip memory       -10 $00004020 $001fffff $0703 (  2.0 MB)
$00200000: VampireChipMem    -11 $00200020 $00b7ffff $0703 (  9.5 MB)
```

V4, from AROS :
```
Address    Name              Pri Lower     Upper     Attrs 
$01000000: expansion.memory   40 $01000020 $07ffffff $0505 (112.0 MB)
$08000000: expansion.memory   40 $08000020 $1fffffff $0505 (384.0 MB)
$00c00000: memory             -5 $00c00000 $00d7ffff $1705 (  1.5 MB)
$00001000: chip memory       -10 $00001000 $00b7ffff $1703 ( 11.5 MB)
$00c01148: Kickstart ROM    -128 $00f80000 $00ffffff $0400 (512.0 KB)
$00c01168: Kickstart ROM    -128 $00e00000 $00e7ffff $0400 (512.0 KB)
```


# VControl MODULES

**SYNOPSIS :**

This command enumerates a number of vampire-related system modules that are loaded.

It should never fail since Exec is always available.

The enumerated modules are of different kinds :

* Exec -> DeviceList
* Exec -> LibList
* Exec -> ResourceList
* Exec -> Residents
* Exec -> Message Ports

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0).

**NOTES :**

(!) This function is experimental and may change in future (!)

**EXAMPLES :**

```
> C:VControl MODULES
Modules information:

Address    Name                     Version 
$08057c9c: 68040.library              40.02
$00e17350: 680x0.library              40.00
$0818c36c: vampiregfx.card            01.30
$00e12e3e: VampireBoot                37.00
$00e001be: VampireFastMem             40.00
$00e001a4: VampireSupport             40.00
$0801aefc: vampire.resource           45.03
$0800009c: vampiresupport.resource    40.41
$0801c34c: processor.resource         44.03
$00000000: sagasd.device         NOT LOADED!
>
```


# VControl SDCLOCKDIV

**SYNOPSIS :**

> NO WARRANTY IS PROVIDED. USE AT YOUR OWN RISK.

This command changes the Vampire `SDPort` speed.

The nominal speed of the `SDPort` is based on the actual Vampire Core frequency, which is represented by the value `0`.

To decrease that speed, the `SDPort` can use a fraction (divider) of the Core frequency.

It applies only to compatible Vampire boards, with an embedded `SDPort` slot.

**INPUT :**

* A valid numeric value, between `0` (fastest) and `255` (slowest).

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

This setting is reset to `0` after every reboot.

This command uses the Vampire `VREG_SDCLKDIV` (`0xde000c`) chipset register.

When accessing an SD card, the SAGA SD driver (`sagasd.device`) queries the card and negotiates the appropriate speed automatically. So, normally, there is no need to set the SDCLOCKDIV manually. However, if you believe that your SD card (along with any intermediate adapters and cables you might have) supports a speed that is higher than the negotiated speed, you can try setting `SDCLOCKDIV` to a faster level and thoroughly testing some data transfer operations. If you do not get any data corruption, you can keep `SDCLOCKDIV` at that faster level.

Setting `SDCLOCKDIV` is only effective after mounting the SD card. (In other words, after `sagasd.device` accesses the SD card and negotiates the initial speed.)

To enable the desired `SDCLOCKDIV` on every boot, you should add the appropriate `VControl SDCLOCKDIV` command to your `S:User-Startup` file, making sure that it runs after the SD card is mounted.

**EXAMPLES :**

```
> C:VControl SDCLOCKDIV=1
SDPort Clock Divider = 1 (Fastest=0, 255=Slowest).
> 
```


# VControl SETENV

**SYNOPSIS :**

This command creates the `VControl Environment Variables` into `ENV:`

Those variables are intended to make life easier for scripting use cases.

**INPUT :**

* None

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

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

In addition, `ENV:` **MUST** be properly assigned before executing this command.

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
		ECHO "Core is outdated, please download latest"
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


# VControl SUPERSCALAR

**SYNOPSIS :**

This command enables or disables the Apollo Core `SuperScalar` mode (Default is Enabled).

SuperScalar is a processor feature which allows to `execute 2 instructions` per fetch, through a `2nd pipe`.

When enabled, the processor works faster, whenever applicable, and even more with programs compiled to take advantage of it (e.g. when compiled for MC68060).

**INPUT :**

* `SUPERSCALAR=0` : Disable the processor SuperScalar mode (1 pipe mode).
* `SUPERSCALAR=1` : Enable the processor SuperScalar mode (2 pipes mode).

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

This setting is **NOT** reset to `0` after a reboot.

This command uses the Motorola™ `Processor Configuration Register` (PCR) register, Bit `Enable SuperScalar` (ESS).

**EXAMPLES :**

```
> C:VControl SUPERSCALAR 0 ; Disable SuperScalar.
SuperScalar: Disabled.
> C:VControl CPU ; Check the effect of the previous command. See PCR line.
Processor information :

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
Processor information :

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

This command enables or disables the so-called Apollo Core `TURTLE` mode.

This feature intends to **HEAVILY** slowdown the processor execution in order to approximate the `MC68000` / `MC68020` speed.

It might help compatibility when launching old Amiga demos and games.

**INPUT :**

* `TURTLE=0` : Disable the TURTLE slow mode.
* `TURTLE=1` : Enable the TURTLE slow mode.

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

This setting is reset to `0` after a reboot.

On **V2** boards,

This command uses the Motorola™ `Cache Control Register` (CACR) register, Bit `Instruction Cache` (ICache).

On **V4** boards,

This command uses the Motorola™ `Processor Configuration Register` (PCR) register, Bit `Enable Turtle` (ETU).

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

This command changes the processor `Vector Base Register` location.

The processor vectors will be moved to a new location, either in CHIP memory (`VBRMOVE=0`) or in FAST memory (`VBRMOVE=1`).

When the processor vectors are moved to FAST memory, it is supposed to increase the system speed, a little.

**INPUT :**

* `VBRMOVE=0` : Chip RAM
* `VBRMOVE=1` : Fast RAM

**OUTPUT :**

* Returns `OK` ($RC = 0) if successful.
* Returns `WARN` ($RC = 5) if failed.

**NOTE :**

This setting is reset to `0` after a reboot.

This command uses the Motorola™ `Vector Base Register` (VBR) register.

This command is compatible with [VBRControl](http://aminet.net/package/util/sys/vbrcontrol).

**EXAMPLES :**

```
> C:VControl VBRMOVE 0 ; Relocate the VBR in CHIP memory.
> C:VControl CPU ; Check the effect of the previous command. See VBR line.
Processor information :

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
Processor information :

CPU:  AC68080 @ 85 MHz (x12) (2p)
FPU:  Is working.
PCR:  0x04400001 (ID: 0440) (REV: 0) (DFP: Off) (ESS: On)
VBR:  0x088599C8 (Vector base is located in FAST Ram)
CACR: 0x80008000 (InstCache: On) (DataCache: On)
ATTN: 0x847f (010,020,030,040,881,882,FPU40,080,PRIVATE)
> 
```




<hr />

> (C) APOLLO-Team 2016-2020 - Last edited : 2020-06-11
