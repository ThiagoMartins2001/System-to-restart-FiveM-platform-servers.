# Script de Reinicialização Automática - Cinelândia

## Descrição
Este projeto automatiza a reinicialização do servidor FiveM nos horários definidos, com limpeza de cache e geração de logs.

## Arquivos Incluídos

- `auto_restart.ps1` - Script principal em PowerShell
- `start_auto_restart.bat` - Atalho para executar o script com um duplo clique
- `config.ps1` - Modelo de configurações (opcional)
- `README.md` - Este guia

## Funcionalidades

✅ **Reinicialização automática** nos horários configurados
✅ **Limpeza total da pasta cache** (remove completamente a pasta para regeneração automática)
✅ **Logs detalhados** de todas as ações
✅ **Reinicialização manual** via teclado

### Sobre a Limpeza de Cache

O script agora remove **completamente** a pasta `cache` durante cada reinicialização. Isso garante que:
- A pasta cache seja totalmente limpa
- O `server.bat` gere uma nova pasta cache limpa ao iniciar
- Evita acúmulo de arquivos corrompidos ou desatualizados
- Melhora a performance do servidor após cada reinicialização

## Estrutura esperada de pastas (mapeamento de arquivos necessários)

Coloque os arquivos deste diretório `server-side` dentro do seu projeto, garantindo que exista a pasta `server` com os seguintes itens:

```
[raiz do projeto]
├─ server
│  ├─ start.bat         (necessário para iniciar o servidor)
│  ├─ cache\            (pasta a ser limpa pelo script)
│  └─ restart_log.txt   (gerado automaticamente pelos logs)
└─ server-side
   ├─ auto_restart.ps1
   ├─ start_auto_restart.bat
   └─ README.md
```

- **Obrigatórios**: `server/start.bat`, pasta `server/cache/`.
- **Gerado**: `server/restart_log.txt` será criado automaticamente.

O `auto_restart.ps1` tenta localizar a pasta `server` automaticamente a partir do diretório atual. Se você executar o `.bat` dentro de `server-side`, essa descoberta deve funcionar sem configuração adicional.

## Configuração do caminho do servidor

### Configuração automática (padrão)
O script tenta localizar automaticamente a pasta `server` a partir do diretório atual. Se você executar o `.bat` dentro de `server-side`, essa descoberta deve funcionar sem configuração adicional.

### Configuração manual do caminho específico
Se você precisar especificar um caminho específico para o servidor (por exemplo, `E:\FiveM\Base CinelandiaV4`), edite o arquivo `auto_restart.ps1`:

**Arquivo:** `server-side/auto_restart.ps1`  
**Linhas:** 17-18

```powershell
# Configurar caminho específico para o servidor
$PROJECT_ROOT = "E:\FiveM\Base CinelandiaV4" 
$SERVER_PATH = $PROJECT_ROOT
```

**Exemplo de configuração:**
- Para o caminho `E:\FiveM\Base CinelandiaV4`, o script irá:
  - Procurar `server.bat` em: `E:\FiveM\Base CinelandiaV4\server.bat`
  - Procurar pasta `cache` em: `E:\FiveM\Base CinelandiaV4\cache`
  - Gerar logs em: `E:\FiveM\Base CinelandiaV4\restart_log.txt`

## Configuração dos horários

Você pode definir os horários de duas formas. A forma recomendada é editar diretamente no `auto_restart.ps1`:

**Arquivo:** `server-side/auto_restart.ps1`  
**Linhas:** 67-68

```powershell
# Configuracoes dos horarios
$HORARIO_1 = "06:00"  # 6:00 da manhã
$HORARIO_2 = "20:10"  # 8:10 da noite
```

Alternativamente, há um `config.ps1` com variáveis de exemplo. Ele não é carregado automaticamente pelo script atual, mas pode servir de referência para padronizar horários e outros ajustes, caso você deseje adaptar o `auto_restart.ps1` para importar esse arquivo.

## Execução

### Opção 1 — Executar pelo `.bat` (recomendado)
1. Dê duplo clique em `start_auto_restart.bat` (dentro de `server-side`).
2. A janela exibirá os horários configurados e começará a monitorar.

### Opção 2 — Executar diretamente no PowerShell
```powershell
powershell.exe -ExecutionPolicy Bypass -File "auto_restart.ps1"
```

## Controles durante a execução

- `R`: Reinicialização manual imediata
- `Q`: Finaliza o script
- Verificações automáticas a cada 30 segundos

## Logs

Os logs são gravados em `server/restart_log.txt`.

Exemplo:
```
[2024-01-15 06:00:00] === INICIANDO REINICIALIZAÇÃO DO SERVIDOR ===
[2024-01-15 06:00:01] Parando o servidor...
[2024-01-15 06:00:03] Servidor parado com sucesso!
[2024-01-15 06:00:08] Iniciando limpeza total da pasta cache...
[2024-01-15 06:00:09] Pasta cache removida completamente com sucesso!
[2024-01-15 06:00:12] Iniciando o servidor...
[2024-01-15 06:00:13] Servidor iniciado com sucesso!
[2024-01-15 06:00:13] === REINICIALIZAÇÃO CONCLUÍDA ===
```

## Requisitos

- Windows 10/11
- PowerShell 5.1 ou superior
- Permissões de administrador (recomendado)

## Solução de problemas

- **Política de execução**: se ocorrer erro, execute no PowerShell:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- **`server` não encontrada**: 
  - **Configuração automática**: garanta que a pasta `server` exista no projeto e que o `.bat`/`.ps1` sejam executados a partir de `server-side` do mesmo projeto.
  - **Configuração manual**: verifique se o caminho especificado nas **linhas 17-18** do `auto_restart.ps1` está correto.

- **`server.bat` não encontrado**: 
  - **Configuração automática**: crie ou ajuste o arquivo em `server/server.bat` (o script chama este arquivo para iniciar o servidor).
  - **Configuração manual**: verifique se o arquivo `server.bat` existe no caminho especificado nas **linhas 17-18** do `auto_restart.ps1`.

- **Cache não limpa**: 
  - **Configuração automática**: verifique a existência de `server/cache/`.
  - **Configuração manual**: verifique se a pasta `cache` existe no caminho especificado nas **linhas 17-18** do `auto_restart.ps1`.

- **Servidor não para**: verifique o processo do FXServer:
```powershell
Get-Process -Name "FXServer" -ErrorAction SilentlyContinue
```

- **Caminho com espaços**: se o caminho do servidor contiver espaços (ex: `E:\FiveM\Base CinelandiaV4`), certifique-se de que está entre aspas nas **linhas 17-18** do `auto_restart.ps1`.

## Versão
1.1 - Agosto 2025