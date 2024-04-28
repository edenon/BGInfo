@echo off

REM Verificar si 7-Zip ya está instalado
if exist "%ProgramFiles%\7-Zip\7z.exe" (
    echo 7-Zip ya está instalado.
) else (
    REM Descargar 7-Zip
    echo Descargando 7-Zip...
    bitsadmin.exe /transfer "Descarga7Zip" https://www.7-zip.org/a/7z1900-x64.exe C:\BGInfo\7z.exe

    REM Instalar 7-Zip
    echo Instalando 7-Zip...
    start /wait C:\BGInfo\7z.exe /S
)

REM Verificar si BGInfo.zip ya existe en el directorio BGInfo
if exist "C:\BGInfo\BGInfo.zip" (
    echo BGInfo.zip ya existe en el directorio BGInfo. No es necesario descargarlo nuevamente.
) else (
    REM Descargar BGInfo.zip desde la URL
    echo Descargando BGInfo.zip...
    bitsadmin.exe /transfer "DescargaBGInfo" https://download.sysinternals.com/files/BGInfo.zip C:\BGInfo\BGInfo.zip
)

REM Descomprimir BGInfo.zip
echo Descomprimiendo BGInfo.zip...
"%ProgramFiles%\7-Zip\7z.exe" x "C:\BGInfo\BGInfo.zip" -o"C:\BGInfo\" -y

REM Verificar si existe el archivo de configuración config.bgi en el directorio BGInfo
if not exist "C:\BGInfo\config.bgi" (
    echo Error: El archivo de configuración config.bgi no se encuentra en el directorio BGInfo.
    pause
    exit /b
)

REM Crear el acceso directo con los parámetros deseados
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\CreateShortcut.vbs"
echo sLinkFile = "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup\BGInfo.lnk" >> "%TEMP%\CreateShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\CreateShortcut.vbs"
echo oLink.TargetPath = "C:\BGInfo\Bginfo.exe" >> "%TEMP%\CreateShortcut.vbs"
echo oLink.Arguments = """C:\BGInfo\config.bgi"" /timer:0 /SILENT /NOLICPROMPT" >> "%TEMP%\CreateShortcut.vbs"
echo oLink.Save >> "%TEMP%\CreateShortcut.vbs"
cscript //nologo "%TEMP%\CreateShortcut.vbs"
del "%TEMP%\CreateShortcut.vbs"

REM Ejecutar el acceso directo
start "" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup\BGInfo.lnk"
  
echo Proceso completado. BGInfo se configuró correctamente.
timeout /t 10 /nobreak >nul
