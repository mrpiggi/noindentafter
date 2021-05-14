@echo off
SET sourcepath=%~dp0
SET sourcepath=%sourcepath:\=/%
SET target=

:arg_loop
IF "%1"=="" GOTO after_loop
SET target=%target% %1
SHIFT
goto arg_loop

:after_loop
IF "%target%"=="" (
  SET target=clean
)
C:\cygwin64\bin\bash --login -c "cd %sourcepath%; make %target%"
pause
