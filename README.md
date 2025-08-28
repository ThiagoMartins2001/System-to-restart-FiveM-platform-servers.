# Sistema de Reinicialização Automática - FiveM

## 📋 Tutorial de Uso

### 1. Preparação
- Coloque os arquivos da pasta `server-side` na raiz do seu projeto FiveM
- Certifique-se de que existe uma pasta `server` com o arquivo `start.bat` para iniciar o servidor

### 2. Configuração dos Horários
Edite o arquivo `auto_restart.ps1` nas linhas 67-68:
```powershell
$HORARIO_1 = "06:00"  # 6:00 da manhã
$HORARIO_2 = "20:10"  # 8:10 da noite
```

### 3. Execução
**Opção Recomendada:** Dê duplo clique em `start_auto_restart.bat`

**Opção Alternativa:** Execute no PowerShell:
```powershell
powershell.exe -ExecutionPolicy Bypass -File "auto_restart.ps1"
```

### 4. Controles Durante a Execução
- **R**: Reinicialização manual imediata
- **Q**: Finalizar o script
- O sistema verifica automaticamente a cada 30 segundos

### 5. Verificação
- Os logs são salvos em `server/restart_log.txt`
- A pasta `cache` é limpa automaticamente a cada reinicialização

---

## 🔧 Como o Sistema Funciona

### Estrutura de Arquivos
```
[seu projeto]
├─ server/
│  ├─ start.bat         (inicia o servidor)
│  ├─ cache/            (pasta limpa automaticamente)
│  └─ restart_log.txt   (logs gerados automaticamente)
└─ server-side/
   ├─ auto_restart.ps1  (script principal)
   ├─ start_auto_restart.bat
   └─ README.md
```

### Funcionamento Interno

**1. Descoberta Automática do Servidor**
- O script localiza automaticamente a pasta `server` a partir do diretório atual
- Se necessário, você pode configurar um caminho específico nas linhas 17-18 do `auto_restart.ps1`

**2. Monitoramento Contínuo**
- Verifica a cada 30 segundos se chegou o horário de reinicialização
- Exibe o status atual e próximos horários na tela

**3. Processo de Reinicialização**
- **Parada**: Encerra o processo FXServer de forma segura
- **Limpeza**: Remove completamente a pasta `cache` para regeneração automática
- **Inicialização**: Executa `server/start.bat` para reiniciar o servidor
- **Logs**: Registra todas as ações com timestamp no `restart_log.txt`

**4. Limpeza de Cache**
- Remove a pasta `cache` inteira (não apenas o conteúdo)
- O `start.bat` regenera automaticamente uma pasta cache limpa
- Evita acúmulo de arquivos corrompidos e melhora performance

**5. Sistema de Logs**
- Todas as ações são registradas com data e hora
- Facilita o diagnóstico de problemas
- Mantém histórico de reinicializações

### Vantagens do Sistema
- ✅ **Automático**: Funciona sem intervenção manual
- ✅ **Limpeza Total**: Cache sempre limpo a cada reinicialização
- ✅ **Logs Detalhados**: Rastreamento completo de todas as ações
- ✅ **Reinicialização Manual**: Controle via tecla R quando necessário
- ✅ **Configurável**: Horários facilmente ajustáveis
- ✅ **Robusto**: Tratamento de erros e verificações de segurança

### Requisitos
- Windows 10/11
- PowerShell 5.1+
- Permissões de administrador (recomendado)

### Solução de Problemas
Se encontrar erros de política de execução:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Autor:** Thiago Martins 
**Versão:** 1.1 - Agosto 2025
