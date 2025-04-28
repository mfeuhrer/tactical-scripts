REM Create Result Status from Parsed Results
SET DSTATUS=%DUPLICATI__PARSED_RESULT%
If %DSTATUS%==Fatal GOTO DSError
If %DSTATUS%==Error GOTO DSError
If %DSTATUS%==Unknown GOTO DSWarning
If %DSTATUS%==Warning GOTO DSWarning
If %DSTATUS%==Success GOTO DSSuccess
GOTO END
:DSError
EVENTCREATE /T ERROR /L APPLICATION /SO Duplicati2 /ID 202 /D "%DUPLICATI__BACKUP_NAME% - Error running Duplicati Backup Job"
GOTO END
:DSWarning
EVENTCREATE /T WARNING /L APPLICATION /SO Duplicati2 /ID 201 /D "%DUPLICATI__BACKUP_NAME% - Warning running Duplicati Backup Job"
GOTO END
:DSSuccess
EVENTCREATE /T SUCCESS /L APPLICATION /SO Duplicati2 /ID 200 /D "%DUPLICATI__BACKUP_NAME% - Success in running Duplicati Backup Job"
GOTO END
:END
SET DSTATUS=