@echo off
::adb��ʱ���뵽path��������
set My_PATH=.\SDK\adb
set PATH=%PATH%;%My_PATH%
md .\bak\ 2>nul 
setlocal enabledelayedexpansion
::�г���װ��app
for /f "usebackq delims=:== tokens=2,3,4" %%i in (`adb shell pm list packages -f -3`) do (

	if "%%k"=="" (set P=%%j) else (set P=%%k) 

	for /f tokens^=2^ delims^=^= %%a in ('adb shell dumpsys package !P! 2^>nul ^|findstr versionName') do set B=%%a
	

	for %%i in (.\bak\*!P!.apk) do (
		echo %%i
		echo !P!
		for /f tokens^=6^ delims^=^' %%a in ('.\SDK\aapt2\aapt2.exe dump badging %%i 2^>nul
		^|findstr /c:"versionName"') do set A=%%a
	)
	ECHO !P!_!B!��!A!

	if "!B!" GTR "!A!" (		
		del .\bak\*!P!.apk 2>nul
		for /f tokens^=4^ delims^=^= %%a in ('adb shell dumpsys package !P! 2^>nul^|findstr targetSdk') do set C=%%a
		if "%%k"=="" (adb pull %%i .\bak\API_!C!_%%j.apk >nul|ECHO �ѱ���) else (adb pull %%i==%%j .\bak\API_!C!_%%k.apk >nul|ECHO �ѱ���) 
		) else (
		echo ����Ҫ����
	)
)
pause


