@echo off
del *.done
del *.rpt
del *.summary
del *.txt
del *.jdi
del *.smsg
del *.pin
del *.cdf
del *.bak
del *.qws
del *.qarlog
del output_files\*.rpt /q /f /s
del output_files\*.pin /q /f /s
del output_files\*.summary /q /f /s
del output_files\*.done /q /f /s
del output_files\*.smsg /q /f /s
del output_files\*.jdi /q /f /s
del output_files\*.cdf /q /f /s
#del simulation\modelsim\*.* /q /f /s
RMDIR /S /Q db
RMDIR /S /Q incremental_db
RMDIR /S /Q greybox_tmp