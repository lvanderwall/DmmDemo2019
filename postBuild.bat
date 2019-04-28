:: postBuild
::	%1 = $(TARGET_NAME)
:: 	%2 = $(TARGET_OUTPUT_FILE)		// *.elf
::	%3 = $(TARGET_OUTPUT_DIR)
::	%4 = $(TARGET_OBJECT_DIR)
::	%5 = $(#AVRDUDE.bin)
::	%6 = $(#AVRDUDE.programmer)
::	%7 = $(MCU)
::
:: codeblocks adds avr-gcc toolchain to path temporarily!

@ECHO OFF
SET "PATH=%PATH%;%~5"
SET "TARGET_NAME=%~1"
SET "TARGET_OUTPUT_FILE=%~2"
SET "TARGET_OUTPUT_BASE=%TARGET_OUTPUT_FILE:~,-4%"
SET "TARGET_OUTPUT_DIR=%~3"
SET "TARGET_OBJECT_DIR=%~4"
SET "PROGRAMMER=%~6"
SET "MCU=%~7"
SET "BIN_EXT=*.d *.eep *.elf *.hex *.map *.lss *.o *.srec"

:: cleanup of binaries and dependency files without "file not found" messages
1>&2 ECHO .
IF "%TARGET_NAME%"=="Clean" (
	1>&2 ECHO -------------- Clean %BIN_EXT% --------------
	
	CD "%TARGET_OUTPUT_DIR%.."
	1>&2 2>NUL DEL /S /Q %BIN_EXT%
	
	CD "%TARGET_OBJECT_DIR%.."
	1>&2 2>NUL DEL /S /Q %BIN_EXT%

) ELSE (
	:: build further binaries
	1>&2 ECHO -------------- Create %BIN_EXT%  --------------
	avr-objcopy.exe -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures  "%TARGET_OUTPUT_FILE%" "%TARGET_OUTPUT_BASE%.hex"
	avr-objcopy.exe -j .eeprom  --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0  --no-change-warnings -O ihex "%TARGET_OUTPUT_FILE%" "%TARGET_OUTPUT_BASE%.eep" || exit 0
	avr-objdump.exe -h -S "%TARGET_OUTPUT_FILE%" > "%TARGET_OUTPUT_BASE%.lss"
	avr-objcopy.exe -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures "%TARGET_OUTPUT_FILE%" "%TARGET_OUTPUT_BASE%.srec"
	avr-size "%TARGET_OUTPUT_FILE%"
	
	:: write hex to microcontroller
	IF "%TARGET_NAME%"=="Program" (
		avrdude -p %MCU% -c %PROGRAMMER% -U "flash:w:%TARGET_OUTPUT_BASE%.hex"
	)
)