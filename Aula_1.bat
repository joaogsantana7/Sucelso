@echo off
REM ============================================================
REM  SCRIPT DE CÓPIA DE ARQUIVOS COM ROBOCOPY
REM  Autor: Roteiro de Prática
REM ============================================================

REM --- CONFIGURAÇÃO -------------------------------------------
REM Defina a pasta de origem (onde estão os arquivos)
set "ORIGEM=C:\Users\SeuUsuario\Documentos\Origem"

REM Defina a pasta de destino (para onde copiar)
set "DESTINO=C:\Users\SeuUsuario\Documentos\Destino"

REM Arquivo de log
set "LOGFILE=%~dp0copia_log_%date:~6,4%%date:~3,2%%date:~0,2%.log"

REM --- OPÇÕES CONFIGURÁVEIS ----------------------------------
REM MODO: "TODOS" = copia tudo | "NOVOS" = só novos/modificados
set "MODO=NOVOS"

REM SUBPASTAS: "SIM" = inclui subpastas | "NAO" = só pasta raiz
set "SUBPASTAS=SIM"

REM SOBRESCREVER: "SIM" = sobrescreve existentes | "NAO" = pula
set "SOBRESCREVER=NAO"

REM ============================================================
REM  NÃO EDITE ABAIXO A MENOS QUE SAIBA O QUE ESTÁ FAZENDO
REM ============================================================

echo.
echo ============================================================
echo  SCRIPT DE CÓPIA - ROBOCOPY
echo ============================================================
echo.
echo  Origem:  "%ORIGEM%"
echo  Destino: "%DESTINO%"
echo  Modo:    %MODO%
echo  Subpastas: %SUBPASTAS%
echo  Sobrescrever: %SOBRESCREVER%
echo.
echo ============================================================
echo.

REM Confirmação do usuário
set /p "CONFIRMA=Deseja continuar? (S/N): "
if /i not "%CONFIRMA%"=="S" (
    echo Operação cancelada pelo usuário.
    pause
    exit /b 0
)

REM Monta os parâmetros do robocopy
set "PARAMS="

REM Incluir subpastas (/E copia subpastas, inclusive vazias)
if /i "%SUBPASTAS%"=="SIM" set "PARAMS=%PARAMS% /E"

REM Copiar somente novos/modificados (/XO exclui mais antigos)
if /i "%MODO%"=="NOVOS" set "PARAMS=%PARAMS% /XO"

REM Não sobrescrever existentes (/XC exclui alterados, /XX mantém extras)
if /i "%SOBRESCREVER%"=="NAO" set "PARAMS=%PARAMS% /XC /XN"

REM Executa o robocopy
echo.
echo Iniciando cópia...
echo.

robocopy "%ORIGEM%" "%DESTINO%" /NP /TEE /LOG+:"%LOGFILE%" %PARAMS%

REM Verifica código de saída do robocopy
REM Códigos 0-7 = sucesso, 8+ = erro
if %ERRORLEVEL% LSS 8 (
    echo.
    echo ============================================================
    echo  CÓPIA CONCLUÍDA COM SUCESSO!
    echo  Log salvo em: "%LOGFILE%"
    echo ============================================================
) else (
    echo.
    echo ============================================================
    echo  ATENÇÃO: OCORRERAM ERROS DURANTE A CÓPIA!
    echo  Verifique o log: "%LOGFILE%"
    echo ============================================================
)

echo.
pause