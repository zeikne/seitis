--[[
	===============================================
	  CONFIGURAÇÃO DO SEITIS NPC
	  by zeikne
	  
	  Coloque este ModuleScript DENTRO do Model do NPC
	  Nome do ModuleScript: Config
	===============================================
]]

local Config = {}

-- ============================================
--  COLOQUE SUA CHAVE DO GROQ AQUI
--  Pegue em: https://console.groq.com
-- ============================================
Config.ApiKey = "gsk_SUA_CHAVE_AQUI"

-- Modelo da IA (recomendados)
-- "llama-3.3-70b-versatile"  → melhor qualidade
-- "llama-3.1-8b-instant"     → mais rápido
Config.Model = "llama-3.3-70b-versatile"

-- Personalidade do NPC (pode mudar à vontade)
Config.SystemPrompt = [[
Você é Seitis, um NPC superinteligente e amigável dentro de um jogo no Roblox.
Responda sempre em português brasileiro de forma divertida, curta e natural (máximo 2-3 frases).
Você conhece o Roblox e gosta de conversar com os jogadores sobre qualquer assunto.
Seja carismático e um pouco engraçado.
]]

-- Distância máxima para o jogador conseguir falar com o NPC (em studs)
Config.MaxDistance = 20

-- Tempo mínimo entre respostas (em segundos) para não spammarem a API
Config.Cooldown = 3

-- Nome que aparece no chat
Config.NpcName = "Seitis"

return Config
