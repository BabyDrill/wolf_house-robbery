---------------| Developed by BabyDrill#7768 |---------------
if Config.ESX.enable then TriggerEvent(Config.ESX.trigger, function(obj) ESX = obj end) end

local TriggerRapina = {}

ESX.RegisterServerCallback('wolf_development:checkitem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local lockpick = xPlayer.getInventoryItem(Config.Lockpick_Item).count
	cb(lockpick)
end)

RegisterNetEvent('wolf_development:avviarapina')
AddEventHandler('wolf_development:avviarapina', function(posizione)
    local src = source
	local poli = Config.Police
	local rapina = 1

	if rapina == 1 then
		local xPlayers = ESX.GetExtendedPlayers(poli.job)

		if #xPlayers >= poli.house_robbery then
			TriggerClientEvent("wolf_development:cercacasa", src)
			WolfDev(LangLog.robbery, ConfigS.Webhook.robbery, ConfigS.Webhook.color.robbery)
			TriggerRapina[src] = true
		else
			TriggerClientEvent('esx:showNotification', src, Lang.police)               
		end	
	end
end)

RegisterNetEvent('wolf_development:toglitem')
AddEventHandler('wolf_development:toglitem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.Lockpick_Item, 1)
end)

RegisterNetEvent('wolf_development:cercaoggetto')
AddEventHandler('wolf_development:cercaoggetto', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local index = math.random(1, #Config.OggettidaTrovare)
    local oggetto = Config.OggettidaTrovare[index]

	if TriggerRapina[source] == false then
		WolfDev(LangLog.mod.." "..GetCurrentResourceName(), ConfigS.Webhook.anticheat, ConfigS.Webhook.color.anticheat)
		DropPlayer(source, "[Anti Trigger] Hai provato a chettare con il server sbagliato! BabyDrill on ToP:)")
	else
		if math.random(1, 20) >= oggetto.chance then
			if oggetto.id == "money" then
				xPlayer.addMoney(oggetto.quantity)
				xPlayer.showNotification('Hai trovato '..oggetto.quantity..'$')
			elseif oggetto.id == "black_money" then
				xPlayer.addAccountMoney('black_money', oggetto.quantity)
				xPlayer.showNotification('Hai trovato '..oggetto.quantity..'$ '..oggetto.label)
			elseif oggetto.id == "item" then
				xPlayer.addInventoryItem(oggetto.name, oggetto.quantity)
				xPlayer.showNotification('Hai trovato '..oggetto.quantity..' '..oggetto.label)
			elseif oggetto.id == "null" then
				xPlayer.showNotification(Lang.null)
			end
		end
	end
end)

RegisterNetEvent('wolf_development:allertapolice')
AddEventHandler('wolf_development:allertapolice', function(id, giocatore)
	if id == 1 then
		TriggerClientEvent('esx:showNotification', source, Lang.allerta1)
		TriggerClientEvent('wolf_development:clientpolice', -1, giocatore)
	end
	if id == 2 then
		TriggerRapina[source] = false
	end
end)

function WolfDev(testo, web, colore)
	if ConfigS.Webhook.enable then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local name = GetPlayerName(_source)
		local now = os.date('%H:%M')
		local steam = "n/a"
		local discord = "n/a"
		local license = "n/a"
		local live = "n/a"
		local xbl = "n/a"
		local ip = "n/a"
		for m, n in ipairs(GetPlayerIdentifiers(_source)) do
			if n:match("steam") then
			   steam = n
			elseif n:match("discord") then
			   discord = n:gsub("discord:", "")
			elseif n:match("license") then
			   license = n
			elseif n:match("live") then
			   live = n
			elseif n:match("xbl") then
			   xbl = n
			elseif n:match("ip") then
			   ip = n:gsub("ip:", "")
			end
		 end
		local pesc = GetPlayerName(_source)
		PerformHttpRequest(web, function()
		end, "POST", json.encode({
			embeds = {{
				author = {
					name = ConfigS.ServerName,
					url = "https://discord.gg/yjPGt2YMcg",
					icon_url = "https://cdn.discordapp.com/attachments/984614435178049576/998558042587140116/WD.png"},
				description = LangLog.player.." "..name.. "\n"..LangLog.id.." ".._source.."\n"..LangLog.steam.." "..steam.. "\n"..LangLog.license.." "..license.. "\n"..LangLog.discord.." ".."<@"..discord..">" .."\n"..LangLog.live.." "..live.. "\n"..LangLog.xbl.." "..xbl.. "\n"..LangLog.ip.." "..ip.."\n"..testo.."\n"..LangLog.tempo.." "..now.. "\n \n **By Wolf Development - BabyDrill on ToP**",
				color = colore
			}}}),{["Content-Type"] = "application/json"})
	end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    wolflogo()
end)

function wolflogo()
    print("^1[Wolf House Robbery]^0 Script by Wolf Development > https://discord.gg/yjPGt2YMcg")
end
---------------| Developed by BabyDrill#7768 |---------------
