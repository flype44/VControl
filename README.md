# VControl

(C) Copyright 2016-2021 APOLLO-Team

The purpose of `VControl` is to bring some valuable information and control over the `Vampire` boards.


# Releases

VControl 1.17 (April 18, 2021)

Latest official binary releases : [Download](https://www.apollo-accelerators.com/wiki/doku.php/saga:updates)


# Features

Latest official documentation : [Open](DOCUMENTATION.md#documentation)


Command | Description
------------ | -------------
DETECT | Detect the AC68080
BOARD | Output Board Information
BOARDID | Output Board Identifier
BOARDNAME | Output Board Name
BOARDSERIAL | Output Board Serial Number
CORE | Output Core Revision String
COREREV | Output Core Revision Number
CPU | Output CPU information
CPUHERTZ | Output CPU Frequency
MEMLIST | Output Memory list
MODULES | Output Modules list
CONFIGDEV | Output ConfigDev list
SETENV | Create Environment Variables
ATTNFLAGS | Change the AttnFlags
AKIKO | Initialize the Akiko C2P routine
DPMS | Change the DPMS mode
FPU | Change the FPU mode
IDESPEED | Change the IDE speed
SDCLOCKDIV | Change the SDPort Clock Divider
SUPERSCALAR | Change the SuperScalar mode
TURTLE | Change the Turtle mode
VBRMOVE | Change the VBR location
JOYPORT | Patch the LowLevel.library to use the GAMEPADs for APOLLO V4(+)
MAPROM | Map a ROM file


# Build instructions

To compile `VControl` you need :

* `SAS/C` 6.59 for CBM AmigaOS3 M68K

  Install and ensure all assets are properly accessible.

* `VASM` 1.8h for CBM AmigaOS3 M68K [Download](http://sun.hasenbraten.de/vasm/bin/rel/vasmm68k_mot_os3.lha)

  Install and ensure `vasmm68k_mot` is properly accessible (in `C:` for example).

* `BoardsLib Developer Kit` [Download](http://aminet.net/dev/misc/CGraphX-DevKit.lha)

  Copy `BoardsLib/Developer/include/c/` folders to `SC:include/`

* `CyberGraph Developer Kit` [Download](http://aminet.net/util/libs/BoardsLib.lha)

  Copy `CGraphX/C/Include/` folders to `SC:include/`

* Use the provided `smakefile`.

  `CD` to the project and type `smake`.

<img src="BuildInstructions.png" />


# Screenshots

<img src="Screenshot01.png" />

<img src="Screenshot02.png" />

<img src="Screenshot03.png" />
