# DMM-Demo 2019 with Code::Blocks (Windows 7)
You don't need a 1.5GB compiler suite like Atmel Studio to get this demo up and running - your programming suite can be small, comfortable *and* do (nearly) everything you want!

This document will give some hints towards a working DMM-Board v3.0 with Code::Blocks on a Windows 7 machine but without either WinAVR *or* Atmel Studio *or* an AVR-Dragon.


## Software prerequisites
Download and install the following software. Take a quick look at your AVR-GCC installation to determine if it contains AVR Libc and/or avrdude already.

Software | Version | Demo 2019 | Comment
-|-|-|-
Code::Blocks | [17.12](http://www.codeblocks.org/downloads/26) | |
AVR-GCC | [8.3.0](http://blog.zakkemble.net/avr-gcc-builds/) | 5.4.0 | AVR-GCC 5.4.0 included in [Atmel Studio 7.0](http://studio.download.atmel.com/7.0.1931/as-installer-7.0.1931-full.exe)
~~AVR Libc~~ | [2.0.0](http://www.nongnu.org/avr-libc/) | 2.0.0 | often included in AVR-GCC
~~avrdude~~ | [6.3](http://savannah.nongnu.org/projects/avrdude/) | | often included in AVR-GCC
PuTTY | [0.71](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) | | for demo program only

If you compile with AVR-GCC 5.4.0 and AVR Libc 2.0.0, your binary should be identical to `Demo.hex`!

## Hardware prerequisites
As we don't want to use an AVR-Dragon or another big programmer, we need an alternative. There are several small ISP-programmers available - they all work with the DMM-Board:

Hardware | Firmware | avrdude -c | Comment
-|-|-|-
DMM-Board v3.0 | | | 
[STK200 programmer](https://www.mikrocontroller.net/articles/STK200) | | stk200 | LPT port required, 4 resistors only!
| [usbasp programmer](https://www.fischl.de/usbasp/) | [2011-05-28](https://www.fischl.de/usbasp/usbasp.2011-05-28.tar.gz) | usbasp | needs firmware

Open the console and check if the DMM-Board is responding to the usbasp programmer:
````
avrdude -p atmega1284 -c usbasp -t
````
That should start interactive mode. Set the fuse bits to to use the 16Mhz chrystal resonator on board as system clock.

## Final steps
1. Unzip the `170530_demo.zip`. Add all files of this repo next to `Demo.c`. Open `DMM-Demo2019.cbp` in Code::Blocks
1. In *Settings -> Compiler -> GNU GCC Compiler for AVR -> Toolchain Executables*: Set Compiler's Installation directory to `$(#AVR_GCC)`
1. Setup the following global variables like in the example. Don't worry, Code::Blocks will remind you to do that if you try to compile. Change the paths according to your installation and fill in your avr programmer (`avrdude -c?` lists all known programmers):

Global variable | Example value | Comment
-|-|-
AVR_GCC.BASE | D:\compiler\avr-gcc-8.3.0-x86-mingw\ | path to AVR-GCC
AVR_LIBC.BASE | D:\compiler\avr-gcc-8.3.0-x86-mingw\avr\ | path to AVR-LIBC
AVRDUDE.BASE | D:\compiler\avr-gcc-8.3.0-x86-mingw\bin\ | path to avrdude.exe
AVRDUDE.programmer | usbasp | avrdude -c option


4. You will find three targets:

Target | Usage
-|-
Clean | delete all binaries
Debug | compiles in "Debug" folder only, no data is sent to your uC
Program | compiles in "Release" folder and sends the binary to your uC

First try *Debug*, then *Clean* and if both compile without errors - *Program* ... and have fun :)

## Final note
The Atmel Studio 7.0 project of the demo compiles with `MCU=atmega1284p`, eventhough the DMM-Board v3.0 contains an ATMega1284. I tried both options and got an identical binary - the Code::Blocks project compiles with `MCU=atmega1284` (as it should, I'd say).