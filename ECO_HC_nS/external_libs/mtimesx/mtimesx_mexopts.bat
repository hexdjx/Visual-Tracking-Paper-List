@echo off
rem MSVC100OPTS.BAT
rem
rem    Compile and link options used for building MEX-files
rem    using the Microsoft Visual C++ compiler version 10.0
rem
rem    $Revision: 1.1.6.4.2.1 $  $Date: 2012/07/12 13:53:59 $
rem    Copyright 2007-2009 The MathWorks, Inc.
rem
rem StorageVersion: 1.0
rem C++keyFileName: MSVC100OPTS.BAT
rem C++keyName: Microsoft Visual C++ 2010
rem C++keyManufacturer: Microsoft
rem C++keyVersion: 10.0
rem C++keyLanguage: C++
rem C++keyLinkerName: Microsoft Visual C++ 2010
rem C++keyLinkerVersion: 10.0
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************

set MATLAB=%MATLAB%
set VSINSTALLDIR=d:\Application Softwares\VS2015
set VCINSTALLDIR=%VSINSTALLDIR%\VC
rem In this case, LINKERDIR is being used to specify the location of the SDK
set LINKERDIR=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\
set PATH=%VCINSTALLDIR%\bin\amd64;%VCINSTALLDIR%\bin;%VCINSTALLDIR%\VCPackages;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\Common7\Tools;%LINKERDIR%\bin\x64;%LINKERDIR%\bin;%MATLAB_BIN%;%PATH%
set INCLUDE=%VCINSTALLDIR%\INCLUDE;%VCINSTALLDIR%\ATLMFC\INCLUDE;%LINKERDIR%\include;%INCLUDE%
set LIB=%VCINSTALLDIR%\LIB\amd64;%VCINSTALLDIR%\ATLMFC\LIB\amd64;%LINKERDIR%\lib\x64;%MATLAB%\extern\lib\win64;%LIB%
set MW_TARGET_ARCH=win64

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=cl
set COMPFLAGS=/c /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo /MD /openmp
set OPTIMFLAGS=/O2 /Oy- /DNDEBUG
set DEBUGFLAGS=/Z7
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win64\microsoft
set LINKER=link
set LINKFLAGS=/dll /export:%ENTRYPOINT% /LIBPATH:"%LIBLOC%" libmx.lib libmex.lib libmat.lib /MACHINE:X64 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /manifest /incremental:NO /implib:"%LIB_NAME%.x" /MAP:"%OUTDIR%%MEX_NAME%%MEX_EXT%.map"
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%%MEX_EXT%.pdb"
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%%MEX_EXT%"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%mexversion.res"
set RC_LINKER=

set POSTLINK_CMDS=del "%LIB_NAME%.x" "%LIB_NAME%.exp"
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%%MEX_EXT%;2" -manifest "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS3=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.map"
