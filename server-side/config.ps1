# Arquivo de Configuração do Script de Reinicialização
# Projeto Cinelândia - Disco E:\Cinelândia
# Modifique os horários abaixo conforme sua preferência

# Configurações de localização
$DISCO_PROJETO = "E"
$CAMINHO_PROJETO = "E:\FiveM\Base CinelandiaV4"
$CAMINHO_SERVIDOR = "E:\FiveM\Base CinelandiaV4"

# Horários de reinicialização automática (formato 24h)
$HORARIO_1 = "06:00"  # 6:00 da manhã
$HORARIO_2 = "20:10"  # 8:10 da noite

# Configurações adicionais
$INTERVALO_VERIFICACAO = 30  # Segundos entre verificações
$DELAY_APOS_REINICIALIZACAO = 120  # Segundos de espera após reinicialização automática
$DELAY_PARADA_SERVIDOR = 5  # Segundos de espera após parar o servidor
$DELAY_ANTES_INICIAR = 3  # Segundos de espera antes de iniciar o servidor

# Configurações de log
$HABILITAR_LOG_DETALHADO = $true
$MANTER_LOG_POR_DIAS = 7  # Manter logs dos últimos 7 dias

# Configurações de cache
$LIMPAR_CACHE = $true
$REMOVER_PASTA_CACHE_COMPLETAMENTE = $true  # Remove toda a pasta cache para regeneração automática

# Configurações de segurança
$TENTATIVAS_MAXIMAS_REINICIALIZACAO = 3
$TIMEOUT_PROCESSO = 10000  # Milissegundos para aguardar processo encerrar 