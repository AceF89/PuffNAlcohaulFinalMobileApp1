@echo off

:: Define source and destination directories
set SOURCE=C:\Users\Nitin\Projects\alcohol-deliver-app-mobile-app
set DEST=C:\Users\Nitin\Projects\Alcohol-Github\PuffNAlcohaulFinalMobileApp1

:: Excluded folders
set EXCLUDE_DIRS="bin" "uploads" "Upload" "obj" ".git" "ElmahLogs" "Logs" "node_modules" ".idea" ".vscode" "build"

:: Use Robocopy to copy files and skip excluded folders recursively
robocopy "%SOURCE%" "%DEST%" /E /R:3 /W:5 /V /XD bin uploads Upload obj .git ElmahLogs Logs node_modules .idea .vscode build

@echo Done copying files!