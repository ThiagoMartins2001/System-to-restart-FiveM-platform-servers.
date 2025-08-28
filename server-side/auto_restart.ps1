# Script de Reinicializacao Automatica do Servidor Cinelandia
# Versao: 1.2 - Corrigido para problemas de codificacao
# Configurado para funcionar sem problemas de caracteres especiais

# Configuracoes do PowerShell
$ErrorActionPreference = "Continue"

Write-Host "=== SCRIPT DE REINICIALIZACAO AUTOMATICA ===" -ForegroundColor Green
Write-Host "Servidor Cinelandia - Versao 1.2" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Green

# Detectar o caminho do projeto usando metodo robusto
$CURRENT_DIR = Get-Location
Write-Host "Diretorio atual: $($CURRENT_DIR.Path)" -ForegroundColor Yellow

# Configurar caminho específico para o servidor
$PROJECT_ROOT = "E:\FiveM\Base CinelandiaV4" 
$SERVER_PATH = $PROJECT_ROOT

# Se nao encontrar server no diretorio atual, procurar nos pais
if (-not (Test-Path $SERVER_PATH)) {
    Write-Host "Procurando pasta server..." -ForegroundColor Yellow
    $tempPath = $PROJECT_ROOT
    for ($i = 0; $i -lt 5; $i++) {
        $parentPath = Split-Path -Parent $tempPath
        # Verificar se o caminho pai existe e nao e vazio
        if ([string]::IsNullOrEmpty($parentPath) -or $parentPath -eq $tempPath) {
            Write-Host "Chegou ao diretorio raiz, parando busca." -ForegroundColor Yellow
            break
        }
        $tempPath = $parentPath
        $testServerPath = Join-Path $tempPath "server"
        Write-Host "Testando caminho: $testServerPath" -ForegroundColor Gray
        if (Test-Path $testServerPath) {
            $PROJECT_ROOT = $tempPath
            $SERVER_PATH = $testServerPath
            Write-Host "Pasta server encontrada em: $SERVER_PATH" -ForegroundColor Green
            break
        }
    }
}

# Verificar se encontrou a pasta server
if (-not (Test-Path $SERVER_PATH)) {
    Write-Host "Tentativa final: usar localizacao do script..." -ForegroundColor Yellow
    # Tentar usar a localizacao do proprio script
    if ($PSScriptRoot) {
        $scriptLocation = $PSScriptRoot
        Write-Host "Script localizado em: $scriptLocation" -ForegroundColor Gray
        # Navegar 4 niveis acima: server-side -> restart -> [update] -> resources
        # O resultado ja sera o diretorio server
        $possibleServerPath = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptLocation)))
        $possibleRoot = Split-Path -Parent $possibleServerPath
        Write-Host "Testando caminho baseado no script: $possibleServerPath" -ForegroundColor Gray
        if (Test-Path $possibleServerPath) {
            $PROJECT_ROOT = $possibleRoot
            $SERVER_PATH = $possibleServerPath
            Write-Host "Pasta server encontrada usando localizacao do script: $SERVER_PATH" -ForegroundColor Green
        }
    }
}

# Verificacao final
if (-not (Test-Path $SERVER_PATH)) {
    Write-Host "ERRO: Nao foi possivel encontrar a pasta server!" -ForegroundColor Red
    Write-Host "Diretorio atual: $($CURRENT_DIR.Path)" -ForegroundColor Red
    Write-Host "Caminho testado: $SERVER_PATH" -ForegroundColor Red
    Write-Host "Verifique se o script esta sendo executado do diretorio correto." -ForegroundColor Red
    Write-Host "O script deve estar em: [projeto]/server/resources/[update]/restart/server-side/" -ForegroundColor Yellow
    pause
    exit 1
}

# Configuracoes dos horarios
$HORARIO_1 = "06:00"  # 6:00 da manha
$HORARIO_2 = "20:10"  # 8:10 da noite

# Caminhos importantes
$START_BAT = Join-Path $SERVER_PATH "server.bat" # Caso seu servidor utilize "Start.bat", substitua o "Server.bat", e faça isso com os demais locais onde aparece "Server.bat"
$CACHE_PATH = Join-Path $SERVER_PATH "cache"
$LOG_FILE = Join-Path $SERVER_PATH "restart_log.txt"

# Verificar se os arquivos existem
Write-Host "Verificando arquivos..." -ForegroundColor Yellow
Write-Host "- server.bat: $(if (Test-Path $START_BAT) { "OK" } else { "NAO ENCONTRADO" })" -ForegroundColor $(if (Test-Path $START_BAT) { "Green" } else { "Red" })
Write-Host "- cache: $(if (Test-Path $CACHE_PATH) { "OK" } else { "NAO ENCONTRADO" })" -ForegroundColor $(if (Test-Path $CACHE_PATH) { "Green" } else { "Red" })

# Funcao para escrever logs
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value $logMessage -ErrorAction SilentlyContinue
}

# Funcao para limpar cache
function Clear-ServerCache {
    Write-Log "Iniciando limpeza total da pasta cache..."
    
    if (Test-Path $CACHE_PATH) {
        try {
            # Remove toda a pasta cache e seu conteúdo
            Remove-Item -Path $CACHE_PATH -Recurse -Force -ErrorAction Stop
            Write-Log "Pasta cache removida completamente com sucesso!"
        }
        catch {
            Write-Log "Erro ao remover pasta cache: $($_.Exception.Message)"
        }
    } else {
        Write-Log "Pasta de cache nao encontrada: $CACHE_PATH"
    }
}

# Funcao para parar o servidor
function Stop-Server {
    Write-Log "Parando o servidor..."
    
    $processes = Get-Process -Name "FXServer" -ErrorAction SilentlyContinue
    if ($processes) {
        $processes | Stop-Process -Force
        Start-Sleep -Seconds 3
        Write-Log "Servidor parado com sucesso!"
    } else {
        Write-Log "Nenhum processo do servidor encontrado."
    }
}

# Funcao para iniciar o servidor
function Start-Server {
    Write-Log "Iniciando o servidor..."
    
    if (Test-Path $START_BAT) {
        Start-Process -FilePath $START_BAT -WorkingDirectory $SERVER_PATH
        Write-Log "Servidor iniciado com sucesso!"
    } else {
        Write-Log "ERRO: Arquivo server.bat nao encontrado: $START_BAT"
    }
}

# Funcao para reinicializar o servidor
function Restart-Server {
    Write-Log "=== INICIANDO REINICIALIZACAO ==="
    Stop-Server
    Start-Sleep -Seconds 5
    Clear-ServerCache
    Start-Sleep -Seconds 3
    Start-Server
    Write-Log "=== REINICIALIZACAO CONCLUIDA ==="
}

# Mostrar configuracao
Write-Log "Script de reinicializacao automatica iniciado"
Write-Host "=== CONFIGURACAO DO SCRIPT ===" -ForegroundColor Cyan
Write-Host "Horario 1: $HORARIO_1" -ForegroundColor White
Write-Host "Horario 2: $HORARIO_2" -ForegroundColor White
Write-Host "Caminho do servidor: $SERVER_PATH" -ForegroundColor White
Write-Host "Arquivo server.bat: $START_BAT" -ForegroundColor White
Write-Host "Pasta de cache: $CACHE_PATH" -ForegroundColor White
Write-Host "Arquivo de log: $LOG_FILE" -ForegroundColor White
Write-Host "===============================" -ForegroundColor Cyan
Write-Host "Script rodando... Pressione 'R' para reinicializacao manual ou 'Q' para sair" -ForegroundColor Green

# Loop principal
while ($true) {
    $currentTime = Get-Date -Format "HH:mm"
    
    # Verificar se e hora de reinicializar
    if ($currentTime -eq $HORARIO_1 -or $currentTime -eq $HORARIO_2) {
        Write-Log "Horario de reinicializacao atingido: $currentTime"
        Restart-Server
        Start-Sleep -Seconds 120  # Esperar 2 minutos antes de verificar novamente
    }
    
    # Verificar se ha tecla pressionada
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        switch ($key.Key) {
            'R' {
                Write-Host "Reinicializacao manual solicitada..." -ForegroundColor Yellow
                Restart-Server
            }
            'Q' {
                Write-Host "Saindo do script..." -ForegroundColor Yellow
                Write-Log "Script encerrado pelo usuario"
                exit 0
            }
        }
    }
    
    Start-Sleep -Seconds 30  # Verificar a cada 30 segundos
}