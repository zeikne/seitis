# Seitis - NPC Inteligente com IA
**by zeikne**

---

## Como colocar no seu jogo Roblox (passo a passo)

### Passo 1 — Criar o NPC
1. Abra o Roblox Studio
2. Crie um **Model** e renomeie para `SeitisNPC`
3. Coloque dentro dele um personagem (pode ser um R15 ou R6 qualquer)
4. Certifique-se que tem:
   - Humanoid
   - HumanoidRootPart

### Passo 2 — Criar os scripts
Dentro do Model `SeitisNPC` crie:

#### A) ModuleScript chamado `Config`
- Clique com botão direito no Model → Insert Object → **ModuleScript**
- Renomeie para `Config`
- Apague tudo que tem dentro e cole o conteúdo do arquivo `Config.lua`

#### B) Script chamado `SeitisAI`
- Clique com botão direito no Model → Insert Object → **Script**
- Renomeie para `SeitisAI`
- Apague tudo e cole o conteúdo do arquivo `SeitisAI.lua`

### Passo 3 — Ativar HTTP
1. Vá em **Home** → **Game Settings** → aba **Security**
2. Marque **Allow HTTP Requests**
3. Salve

### Passo 4 — Colocar sua chave
1. Abra o ModuleScript `Config`
2. Troque a linha:
   ```lua
   Config.ApiKey = "gsk_SUA_CHAVE_AQUI"
   ```
   pela sua chave real do Groq (pegue em https://console.groq.com)

### Passo 5 — Testar
1. Aperte **Play**
2. Vá perto do NPC
3. Vai aparecer o prompt **"Falar com Seitis"**
4. Ou digite no chat:
   ```
   /falar oi, quem é você?
   ```

Pronto! O Seitis vai responder com inteligência artificial.

