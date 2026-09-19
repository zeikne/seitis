--[[
	===============================================
	  SEITIS AI
	  by zeikne
	  
	  Coloque este SCRIPT (não LocalScript) DENTRO do Model do NPC
	===============================================
]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")
local TextChatService = game:GetService("TextChatService")


local Config = require(script.Parent:WaitForChild("Config"))

local npc = script.Parent
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local rootPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc.PrimaryPart

if not rootPart then
	warn("[SeitisAI] Não encontrei HumanoidRootPart/Torso no NPC!")
	return
end


local lastTalk = {}


local function askGroq(playerMessage)
	local url = "https://api.groq.com/openai/v1/chat/completions"

	local body = {
		model = Config.Model,
		temperature = 0.75,
		max_tokens = 300,
		messages = {
			{
				role = "system",
				content = Config.SystemPrompt
			},
			{
				role = "user",
				content = playerMessage
			}
		}
	}

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "POST",
			Headers = {
				["Authorization"] = "Bearer " .. Config.ApiKey,
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode(body)
		})
	end)

	if not success then
		return "Desculpe, meu cérebro deu um tilt... (erro de conexão)"
	end

	if response.StatusCode == 200 then
		local data = HttpService:JSONDecode(response.Body)
		if data.choices and data.choices[1] and data.choices[1].message then
			return data.choices[1].message.content
		end
	elseif response.StatusCode == 401 then
		return "Erro: API Key inválida. Verifique o Config."
	elseif response.StatusCode == 429 then
		return "Estou pensando demais... tenta de novo em alguns segundos."
	else
		return "Erro na IA (" .. tostring(response.StatusCode) .. ")"
	end

	return "Não consegui pensar em nada agora..."
end


local function responder(player, mensagem)
	if not player or not player.Character then return end


	local charRoot = player.Character:FindFirstChild("HumanoidRootPart")
	if not charRoot then return end

	local distancia = (charRoot.Position - rootPart.Position).Magnitude
	if distancia > Config.MaxDistance then
		return
	end


	local now = tick()
	if lastTalk[player.UserId] and (now - lastTalk[player.UserId]) < Config.Cooldown then
		return
	end
	lastTalk[player.UserId] = now


	local thinkingMsg = "[" .. Config.NpcName .. "]: Pensando... 🧠"
	

	pcall(function()
		if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then

			local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			if channel then
				channel:DisplaySystemMessage(thinkingMsg)
			end
		else

			Chat:Chat(rootPart, "Pensando...", Enum.ChatColor.Blue)
		end
	end)


	task.spawn(function()
		local resposta = askGroq(mensagem)


		pcall(function()
			if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
				local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
				if channel then
					channel:DisplaySystemMessage("[" .. Config.NpcName .. "]: " .. resposta)
				end
			else
				Chat:Chat(rootPart, resposta, Enum.ChatColor.Green)
			end
		end)


		pcall(function()
			Chat:Chat(rootPart, resposta)
		end)
	end)
end


local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Falar com Seitis"
prompt.ObjectText = Config.NpcName
prompt.HoldDuration = 0
prompt.MaxActivationDistance = 10
prompt.RequiresLineOfSight = false
prompt.Parent = rootPart

prompt.Triggered:Connect(function(player)
	responder(player, "Olá! Quem é você e o que você faz aqui neste jogo?")
end)


Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		local lower = string.lower(message)


		if string.sub(lower, 1, 6) == "/falar" then
			local texto = string.sub(message, 8)
			if texto and #texto > 0 then
				responder(player, texto)
			end
		end
	end)
end)


for _, player in ipairs(Players:GetPlayers()) do
	player.Chatted:Connect(function(message)
		local lower = string.lower(message)
		if string.sub(lower, 1, 6) == "/falar" then
			local texto = string.sub(message, 8)
			if texto and #texto > 0 then
				responder(player, texto)
			end
		end
	end)
end

print("[SeitisAI] NPC inteligente carregado com sucesso! | by zeikne")
