---------------| Developed by BabyDrill#7768 |---------------
if Config.ESX.enable then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent(Config.ESX.trigger, function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        PlayerData = ESX.GetPlayerData()
    end)
end

-- PARTE LOCAL
local Rapinando = false
local HouseRobb = false
local Nui = false
local TempoRapina = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        TempoRapina = false
        Citizen.Wait(Config.Tempo * 60000)
    end
end)

-- PARTE LESTER
Citizen.CreateThread(function()
    Wait(250)
    local caz = Config.Marker.lester
    local ped = Config.Lester.marker
    local lester = Config.Lester.ped

    TriggerEvent('gridsystem:registerMarker', {
        name = 'rapina_lester',
        pos = vector3(ped.x, ped.y, ped.z),
        size = vector3(2.1,2.1,2.1),
        scale = caz.scale,
        color = caz.colour,
        drawDistance = caz.distance,
        msg = Lang.lester,
        control = caz.key,
        type = caz.id,
        action = function()
            if Rapinando == false then 
                if TempoRapina == false then
                    TriggerServerEvent("wolf_development:avviarapina")
                else
                    ESX.ShowNotification(Lang.aspetta)
                end
            else
                ESX.ShowNotification(Lang.rapinaon)
            end
        end
    })
-----------------------------------BLIP LESTER------------------------------------
    local babydrill = AddBlipForCoord(ped.x, ped.y, ped.z)
	SetBlipSprite(babydrill, 77)
	SetBlipScale(babydrill, 0.7)
	SetBlipColour(babydrill, 1)
	SetBlipAsShortRange(babydrill, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(Lang.blip_lester)
	EndTextCommandSetBlipName(babydrill)
------------------------------------PED MODEL--------------------------------------
    RequestModel(lester.id)
	while not HasModelLoaded(lester.id) do
		Wait(0)
	end
	local ped_lester = CreatePed(4, lester.id, lester.x, lester.y, lester.z, lester.h)
	SetEntityHeading(ped_lester, lester.h)
	FreezeEntityPosition(ped_lester, true)
    SetBlockingOfNonTemporaryEvents(ped_lester, true)
    SetEntityInvincible(ped_lester, true)
end)

RegisterNetEvent("wolf_development:cercacasa")
AddEventHandler("wolf_development:cercacasa", function()
    ESX.UI.Menu.CloseAll()
    Rapinando = true
    TempoRapina = true
    local pedid = PlayerPedId()
    FreezeEntityPosition(pedid, true)
    RequestAnimDict("anim@amb@casino@hangout@ped_male@stand@02b@idles")
    while (not HasAnimDictLoaded("anim@amb@casino@hangout@ped_male@stand@02b@idles")) do Citizen.Wait(0) end
    TaskPlayAnim(pedid,"anim@amb@casino@hangout@ped_male@stand@02b@idles","idle_a",8.0, -8.0, -1, 0, 0, false, false, false)
    progress(Lang.progressbar, 5000)
    ClearPedTasks(pedid)
	FreezeEntityPosition(pedid, false)
    local index = math.random(1, #Config.House)
    local blip_posizione = Config.House[index]
    local bliprapina = AddBlipForCoord(blip_posizione.x, blip_posizione.y, blip_posizione.z)
    SetNewWaypoint(blip_posizione.x, blip_posizione.y, blip_posizione.z)
	SetBlipSprite(bliprapina, 430)
	SetBlipScale(bliprapina, 0.5)
	SetBlipColour(bliprapina, 1)
	SetBlipAsShortRange(bliprapina, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(Lang.house_blip)
	EndTextCommandSetBlipName(bliprapina)
    ESX.ShowNotification(Lang.start_robbery)
    local caz = Config.Marker.house_robbery
    local entratincasa = false
    HouseRobb = false
    TriggerEvent('gridsystem:registerMarker', {
        name = 'house_robbery',
        pos = vector3(blip_posizione.x, blip_posizione.y, blip_posizione.z),
        size = vector3(2.1,2.1,2.1),
        scale = caz.scale,
        color = caz.colour,
        drawDistance = caz.distance,
        msg = Lang.house,
        control = caz.key,
        type = caz.id,
        action = function()
            if entratincasa == false then
                if GetVehiclePedIsIn(pedid, false) ~= 0 then
                    ESX.ShowNotification(Lang.veicolo)
                else
                    if HouseRobb == false then
                        ESX.TriggerServerCallback('wolf_development:checkitem', function(lockpick)
                            if lockpick >= 1 then
                                entratincasa = true
                                FreezeEntityPosition(pedid, true)
                                RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                                while (not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")) do Citizen.Wait(0) end
                                TaskPlayAnim(PlayerPedId(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",8.0, 8.0, -1, 80, 0, 0, 0, 0)
                                progress(Lang.scassinando, 10000)
                                ClearPedTasks(pedid)
                                FreezeEntityPosition(pedid, false)
                                TriggerServerEvent("wolf_development:toglitem")
                                ESX.ShowNotification(Lang.door_broke)
                                EsciDaCasa({x = blip_posizione.x, y = blip_posizione.y, z = blip_posizione.z-50})
                                CreaOggettiCasa({x = blip_posizione.x, y = blip_posizione.y, z = blip_posizione.z-50})
                                CasaMomentanea({x = blip_posizione.x, y = blip_posizione.y, z = blip_posizione.z-50})
                                entratincasa = false
                            else
                                ESX.ShowNotification(Lang.lockpick)
                            end
                        end)
                    else
                        ESX.ShowNotification(Lang.rapinaoff)
                    end
                end
            end
        end
    })
end)

function CreaOggettiCasa(pos_casa)
    local cercaogg1 = false
    local cercaogg2 = false
    local cercaogg3 = false
    local cercaogg4 = false
    local cercaogg5 = false
    Oggettinellafottutacasa = {
        [1] = { id = 1, x = pos_casa.x+2.6, y = pos_casa.y+2, z = pos_casa.z+2.1, h = "nella libreria"},
        [2] = { id = 2, x = pos_casa.x+1.5, y = pos_casa.y-3.8, z = pos_casa.z+2.1, h = "nel frigorifero"},
        [3] = { id = 3, x = pos_casa.x+7.6, y = pos_casa.y+4.1, z = pos_casa.z+2.1, h = "nell'armadio"},
        [4] = { id = 4, x = pos_casa.x-5, y = pos_casa.y+1, z = pos_casa.z+2.1, h = "nei cassetti"},
        [5] = { id = 5, x = pos_casa.x-1.9, y = pos_casa.y-6.5, z = pos_casa.z+2.1, h = "nella mensola"},
    }--x = destra/sinistra y = avanti/dietro

    for k,v in pairs(Oggettinellafottutacasa) do
        TriggerEvent('gridsystem:registerMarker', {
            name = 'oggettidarubare:'..v.id,  
            pos = vector3(v.x, v.y, v.z),
            scale = vector3(1.5, 1.5, 1.5),
            size = vector3(2.5, 2.5, 2.5),
            msg = '~r~[E] ~w~Cerca '..v.h,
            type = -1,
            drawDistance = 1,
            show3D = true,
            control = 'E',
            action = function()
                local pedid = PlayerPedId()

                FreezeEntityPosition(pedid, true)
                RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
                while (not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@")) do Citizen.Wait(0) end
                TaskPlayAnim(pedid,"anim@amb@business@weed@weed_inspecting_lo_med_hi@","weed_crouch_checkingleaves_idle_03_inspector",8.0, -8.0, -1, 0, 0, false, false, false)
                progress(Lang.cercandon.." "..v.h, 10000)
                local posiz = vector3(v.x, v.y, v.z)
                if v.id == 1 then
                    if cercaogg1 == false then
                        TriggerServerEvent("wolf_development:cercaoggetto", posiz)
                        cercaogg1 = true
                    else
                        ESX.ShowNotification(Lang.cercaoff)
                    end
                end
                if v.id == 2 then
                    if cercaogg2 == false then
                        TriggerServerEvent("wolf_development:cercaoggetto", posiz)
                        cercaogg2 = true
                    else
                        ESX.ShowNotification(Lang.cercaoff)
                    end
                end
                if v.id == 3 then
                    if cercaogg3 == false then
                        TriggerServerEvent("wolf_development:cercaoggetto", posiz)
                        cercaogg3 = true
                    else
                        ESX.ShowNotification(Lang.cercaoff)
                    end
                end
                if v.id == 4 then
                    if cercaogg4 == false then
                        TriggerServerEvent("wolf_development:cercaoggetto", posiz)
                        cercaogg4 = true
                    else
                        ESX.ShowNotification(Lang.cercaoff)
                    end
                end
                if v.id == 5 then
                    if cercaogg5 == false then
                        TriggerServerEvent("wolf_development:cercaoggetto", posiz)
                        cercaogg5 = true
                    else
                        ESX.ShowNotification(Lang.cercaoff)
                    end
                end
                ClearPedTasks(pedid)
                FreezeEntityPosition(pedid, false)
            end
        })
    end
end

function EsciDaCasa(pos_casa)
    local caz = Config.Marker.house_robbery
    TriggerEvent('gridsystem:registerMarker', {
        name = 'esci_rapina',
        pos = vector3(pos_casa.x+3.7, pos_casa.y-15.6, pos_casa.z+2.1),
        size = vector3(2.1,2.1,2.1),
        scale = caz.scale,
        color = caz.colour,
        drawDistance = caz.distance,
        msg = Lang.esci_rapina,
        control = caz.key,
        type = caz.id,
        action = function()
            DistruggiCasa({x = pos_casa.x, y = pos_casa.y, z = pos_casa.z+50})
        end
    })
end

function DistruggiCasa(pos_casa)
    SetEntityCoords(PlayerPedId(), pos_casa.x, pos_casa.y, pos_casa.z)
    HouseRobb = true
    Rapinando = false
    cercaogg1 = false
    cercaogg2 = false
    cercaogg3 = false
    cercaogg4 = false
    cercaogg5 = false
    Nui = false
    RemoveBlip(bliprapina)
    TriggerEvent("wolf_development:stoppa")
    local giocatore = GetEntityCoords(PlayerPedId(-1))
    TriggerServerEvent("wolf_development:allertapolice", 2, giocatore)
end

function CasaMomentanea(pos_casa)
    RequestModel(GetHashKey("clrp_house_1"))
    SetEntityCoords(PlayerPedId(), 346.75036621094,-1012.8656616211,-99.196258544922)
    SetEntityHeading(PlayerPedId(), 358.106)
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.Wait(2000)
    while not HasModelLoaded(GetHashKey("clrp_house_1")) do
      Citizen.Wait(100)
    end
    local building = CreateObject(GetHashKey("clrp_house_1"), pos_casa.x, pos_casa.y-0.05, pos_casa.z+1.26253700-89.825, false, false, false)
    if building then
      FreezeEntityPosition(building, true)
      Citizen.Wait(1000)
      SetEntityCoords(PlayerPedId(), pos_casa.x+3.6, pos_casa.y-14.8, pos_casa.z+2.9)
      SetEntityHeading(PlayerPedId(), 358.106)
      local dt = CreateObject(GetHashKey("V_16_DT"), pos_casa.x-1.21854400, pos_casa.y-1.04389600, pos_casa.z+1.39068600, false, false, false)
      local mpmid01 = CreateObject(GetHashKey("V_16_mpmidapart01"), pos_casa.x+0.52447510, pos_casa.y-5.04953700, pos_casa.z+1.32, false, false, false)
      local mpmid09 = CreateObject(GetHashKey("V_16_mpmidapart09"), pos_casa.x+0.82202150, pos_casa.y+2.29612000, pos_casa.z+1.88, false, false, false)
      local mpmid07 = CreateObject(GetHashKey("V_16_mpmidapart07"), pos_casa.x-1.91445900, pos_casa.y-6.61911300, pos_casa.z+1.45, false, false, false)
      local mpmid03 = CreateObject(GetHashKey("V_16_mpmidapart03"), pos_casa.x-4.82565300, pos_casa.y-6.86803900, pos_casa.z+1.14, false, false, false)
      local midData = CreateObject(GetHashKey("V_16_midapartdeta"), pos_casa.x+2.28558400, pos_casa.y-1.94082100, pos_casa.z+1.32, false, false, false)
      local glow = CreateObject(GetHashKey("V_16_treeglow"), pos_casa.x-1.37408500, pos_casa.y-0.95420070, pos_casa.z+1.135, false, false, false)
      local curtins = CreateObject(GetHashKey("V_16_midapt_curts"), pos_casa.x-1.96423300, pos_casa.y-0.95958710, pos_casa.z+1.280, false, false, false)
      local mpmid13 = CreateObject(GetHashKey("V_16_mpmidapart13"), pos_casa.x-4.65580700, pos_casa.y-6.61684000, pos_casa.z+1.259, false, false, false)
      local mpcab = CreateObject(GetHashKey("V_16_midapt_cabinet"), pos_casa.x-1.16177400, pos_casa.y-0.97333810, pos_casa.z+1.27, false, false, false)
      local mpdecal = CreateObject(GetHashKey("V_16_midapt_deca"), pos_casa.x+2.311386000, pos_casa.y-2.05385900, pos_casa.z+1.297, false, false, false)
      local mpdelta = CreateObject(GetHashKey("V_16_mid_hall_mesh_delta"), pos_casa.x+3.69693000, pos_casa.y-5.80020100, pos_casa.z+1.293, false, false, false)
      local beddelta = CreateObject(GetHashKey("V_16_mid_bed_delta"), pos_casa.x+7.95187400, pos_casa.y+1.04246500, pos_casa.z+1.28402300, false, false, false)
      local bed = CreateObject(GetHashKey("V_16_mid_bed_bed"), pos_casa.x+6.86376900, pos_casa.y+1.20651200, pos_casa.z+1.33589100, false, false, false)
      local beddecal = CreateObject(GetHashKey("V_16_MID_bed_over_decal"), pos_casa.x+7.82861300, pos_casa.y+1.04696700, pos_casa.z+1.34753700, false, false, false)
      local bathDelta = CreateObject(GetHashKey("V_16_mid_bath_mesh_delta"), pos_casa.x+4.45460500, pos_casa.y+3.21322800, pos_casa.z+1.21116100, false, false, false)
      local bathmirror = CreateObject(GetHashKey("V_16_mid_bath_mesh_mirror"), pos_casa.x+3.57740800, pos_casa.y+3.25032000, pos_casa.z+1.48871300, false, false, false)
      local beerbot = CreateObject(GetHashKey("Prop_CS_Beer_Bot_01"), pos_casa.x+1.73134600, pos_casa.y-4.88520200, pos_casa.z+1.91083000, false, false, false)
      local couch = CreateObject(GetHashKey("v_res_mp_sofa"), pos_casa.x-1.48765600, pos_casa.y+1.68100600, pos_casa.z+1.33640500, false, false, false)
      local chair = CreateObject(GetHashKey("v_res_mp_stripchair"), pos_casa.x-4.44770800, pos_casa.y-1.78048800, pos_casa.z+1.21640500, false, false, false)
      local chair2 = CreateObject(GetHashKey("v_res_tre_chair"), pos_casa.x+2.91325400, pos_casa.y-5.27835100, pos_casa.z+1.22746400, false, false, false)
      local plant = CreateObject(GetHashKey("Prop_Plant_Int_04a"), pos_casa.x+2.78941300, pos_casa.y-4.39133900, pos_casa.z+2.12746400, false, false, false)
      local lamp = CreateObject(GetHashKey("v_res_d_lampa"), pos_casa.x-3.61473100, pos_casa.y-6.61465100, pos_casa.z+2.09373700, false, false, false)
      local fridge = CreateObject(GetHashKey("v_res_fridgemodsml"), pos_casa.x+1.90339700, pos_casa.y-3.80026800, pos_casa.z+1.29917900, false, false, false)
      local micro = CreateObject(GetHashKey("prop_micro_01"), pos_casa.x+2.03442400, pos_casa.y-4.64585100, pos_casa.z+2.28995600, false, false, false)
      local sideBoard = CreateObject(GetHashKey("V_Res_Tre_SideBoard"), pos_casa.x+2.84053000, pos_casa.y-4.30947100, pos_casa.z+1.24577300, false, false, false)
      local bedSide = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), pos_casa.x-3.50363200, pos_casa.y-6.55289400, pos_casa.z+1.30625800, false, false, false)
      local lamp2 = CreateObject(GetHashKey("v_res_d_lampa"), pos_casa.x+2.69674700, pos_casa.y-3.83123500, pos_casa.z+2.09373700, false, false, false)
      local plant2 = CreateObject(GetHashKey("v_res_tre_tree"), pos_casa.x-4.96064800, pos_casa.y-6.09898500, pos_casa.z+1.31631400, false, false, false)
      local table = CreateObject(GetHashKey("V_Res_M_DineTble_replace"), pos_casa.x-3.50712600, pos_casa.y-4.13621600, pos_casa.z+1.29625800, false, false, false)
      local tv = CreateObject(GetHashKey("Prop_TV_Flat_01"), pos_casa.x-5.53120400, pos_casa.y+0.76299670, pos_casa.z+2.17236000, false, false, false)
      local plant3 = CreateObject(GetHashKey("v_res_tre_plant"), pos_casa.x-5.14112800, pos_casa.y-2.78951000, pos_casa.z+1.25950800, false, false, false)
      local chair3 = CreateObject(GetHashKey("v_res_m_dinechair"), pos_casa.x-3.04652400, pos_casa.y-4.95971200, pos_casa.z+1.19625800, false, false, false)
      local lampStand = CreateObject(GetHashKey("v_res_m_lampstand"), pos_casa.x+1.26588400, pos_casa.y+3.68883900, pos_casa.z+1.35556700, false, false, false)
      local stool = CreateObject(GetHashKey("V_Res_M_Stool_REPLACED"), pos_casa.x-3.23216300, pos_casa.y+2.06159000, pos_casa.z+1.20556700, false, false, false)
      local chair4 = CreateObject(GetHashKey("v_res_m_dinechair"), pos_casa.x-2.82237200, pos_casa.y-3.59831300, pos_casa.z+1.25950800, false, false, false)
      local chair5 = CreateObject(GetHashKey("v_res_m_dinechair"), pos_casa.x-4.14955100, pos_casa.y-4.71316600, pos_casa.z+1.19625800, false, false, false)
      local chair6 = CreateObject(GetHashKey("v_res_m_dinechair"), pos_casa.x-3.80622900, pos_casa.y-3.37648300, pos_casa.z+1.19625800, false, false, false)
      local plant4 = CreateObject(GetHashKey("v_res_fa_plant01"), pos_casa.x+2.97859200, pos_casa.y+2.55307400, pos_casa.z+1.85796300, false, false, false)
      local storage = CreateObject(GetHashKey("v_res_tre_storageunit"), pos_casa.x+8.47819500, pos_casa.y-2.50979300, pos_casa.z+1.19712300, false, false, false)
      local storage2 = CreateObject(GetHashKey("v_res_tre_storagebox"), pos_casa.x+9.75982700, pos_casa.y-1.35874100, pos_casa.z+1.29625800, false, false, false)
      local basketmess = CreateObject(GetHashKey("v_res_tre_basketmess"), pos_casa.x+8.70730600, pos_casa.y-2.55503600, pos_casa.z+1.94059590, false, false, false)
      local lampStand2 = CreateObject(GetHashKey("v_res_m_lampstand"), pos_casa.x+9.54306000, pos_casa.y-2.50427700, pos_casa.z+1.30556700, false, false, false)
      local plant4 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), pos_casa.x+9.87521400, pos_casa.y+3.90917400, pos_casa.z+1.20829700, false, false, false)
      local basket = CreateObject(GetHashKey("v_res_tre_washbasket"), pos_casa.x+9.39091500, pos_casa.y+4.49676300, pos_casa.z+1.19625800, false, false, false)
      local wardrobe = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), pos_casa.x+8.46626300, pos_casa.y+4.53223600, pos_casa.z+1.19425800, false, false, false)
      local basket2 = CreateObject(GetHashKey("v_res_tre_flatbasket"), pos_casa.x+8.51593000, pos_casa.y+4.55647300, pos_casa.z+3.46737300, false, false, false)
      local basket3 = CreateObject(GetHashKey("v_res_tre_basketmess"), pos_casa.x+7.57797200, pos_casa.y+4.55198800, pos_casa.z+3.46737300, false, false, false)
      local basket4 = CreateObject(GetHashKey("v_res_tre_flatbasket"), pos_casa.x+7.12286400, pos_casa.y+4.54689200, pos_casa.z+3.46737300, false, false, false)
      local wardrobe2 = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), pos_casa.x+7.24382000, pos_casa.y+4.53423500, pos_casa.z+1.19625800, false, false, false)
      local basket5 = CreateObject(GetHashKey("v_res_tre_flatbasket"), pos_casa.x+8.03364600, pos_casa.y+4.54835500, pos_casa.z+3.46737300, false, false, false)
      local switch = CreateObject(GetHashKey("v_serv_switch_2"), pos_casa.x+6.28086900, pos_casa.y-0.68169880, pos_casa.z+2.30326000, false, false, false)
      local table2 = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), pos_casa.x+5.84416200, pos_casa.y+2.57377400, pos_casa.z+1.22089100, false, false, false)
      local lamp3 = CreateObject(GetHashKey("v_res_d_lampa"), pos_casa.x+5.84912100, pos_casa.y+2.58001100, pos_casa.z+1.95311890, false, false, false)
      local laundry = CreateObject(GetHashKey("v_res_mlaundry"), pos_casa.x+5.77729800, pos_casa.y+4.60211400, pos_casa.z+1.19674400, false, false, false)--
      local ashtray = CreateObject(GetHashKey("Prop_ashtray_01"), pos_casa.x-1.24716200, pos_casa.y+1.07820500, pos_casa.z+1.87089300, false, false, false)
      local candle1 = CreateObject(GetHashKey("v_res_fa_candle03"), pos_casa.x-2.89289900, pos_casa.y-4.35329700, pos_casa.z+2.02881310, false, false, false)
      local candle2 = CreateObject(GetHashKey("v_res_fa_candle02"), pos_casa.x-3.99865700, pos_casa.y-4.06048500, pos_casa.z+2.02530190, false, false, false)
      local candle3 = CreateObject(GetHashKey("v_res_fa_candle01"), pos_casa.x-3.37733400, pos_casa.y-3.66639800, pos_casa.z+2.02526200, false, false, false)
      local woodbowl = CreateObject(GetHashKey("v_res_m_woodbowl"), pos_casa.x-3.50787400, pos_casa.y-4.11983000, pos_casa.z+2.02589900, false, false, false)
      local tablod = CreateObject(GetHashKey("V_Res_TabloidsA"), pos_casa.x-0.80513000, pos_casa.y+0.51389600, pos_casa.z+1.18418800, false, false, false)
      local tapeplayer = CreateObject(GetHashKey("Prop_Tapeplayer_01"), pos_casa.x-1.26010100, pos_casa.y-3.62966400, pos_casa.z+2.37883200, false, false, false)
      local woodbowl2 = CreateObject(GetHashKey("v_res_tre_fruitbowl"), pos_casa.x+2.77764900, pos_casa.y-4.138297000, pos_casa.z+2.10340100, false, false, false)
      local sculpt = CreateObject(GetHashKey("v_res_sculpt_dec"), pos_casa.x+3.03932200, pos_casa.y+1.62726400, pos_casa.z+3.58363900, false, false, false)
      local jewlry = CreateObject(GetHashKey("v_res_jewelbox"), pos_casa.x+3.04164100, pos_casa.y+0.31671810, pos_casa.z+3.58363900, false, false, false)
      local basket6 = CreateObject(GetHashKey("v_res_tre_basketmess"), pos_casa.x-1.64906300, pos_casa.y+1.62675900, pos_casa.z+1.39038500, false, false, false)
      local basket7 = CreateObject(GetHashKey("v_res_tre_flatbasket"), pos_casa.x-1.63938900, pos_casa.y+0.91133310, pos_casa.z+1.39038500, false, false, false)
      local basket8 = CreateObject(GetHashKey("v_res_tre_flatbasket"), pos_casa.x-1.19923400, pos_casa.y+1.69598600, pos_casa.z+1.39038500, false, false, false)
      local basket9 = CreateObject(GetHashKey("v_res_tre_basketmess"), pos_casa.x-1.18293800, pos_casa.y+0.91436380, pos_casa.z+1.39038500, false, false, false)
      local bowl = CreateObject(GetHashKey("v_res_r_sugarbowl"), pos_casa.x-0.26029210, pos_casa.y-6.66716800, pos_casa.z+3.77324900, false, false, false)
      local breadbin = CreateObject(GetHashKey("Prop_Breadbin_01"), pos_casa.x+2.09788500, pos_casa.y-6.57634000, pos_casa.z+2.24041900, false, false, false)
      local knifeblock = CreateObject(GetHashKey("v_res_mknifeblock"), pos_casa.x+1.82084700, pos_casa.y-6.58438500, pos_casa.z+2.27399500, false, false, false)
      local toaster = CreateObject(GetHashKey("prop_toaster_01"), pos_casa.x-1.05790700, pos_casa.y-6.59017400, pos_casa.z+2.26793200, false, false, false)
      local wok = CreateObject(GetHashKey("prop_wok"), pos_casa.x+2.01728800, pos_casa.y-5.57091500, pos_casa.z+2.31793200, false, false, false)
      local plant5 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), pos_casa.x+2.55015600, pos_casa.y+4.60183900, pos_casa.z+1.20829700, false, false, false)
      local tumbler = CreateObject(GetHashKey("p_tumbler_cs2_s"), pos_casa.x-0.90916440, pos_casa.y-4.24099100, pos_casa.z+2.24693200, false, false, false)
      local wisky = CreateObject(GetHashKey("p_whiskey_bottle_s"), pos_casa.x-0.92809300, pos_casa.y-3.99099100, pos_casa.z+2.24693200, false, false, false)
      local tissue = CreateObject(GetHashKey("v_res_tissues"), pos_casa.x+7.95889300, pos_casa.y-2.54847100, pos_casa.z+1.94013400, false, false, false)
      local pants = CreateObject(GetHashKey("V_16_Ap_Mid_Pants4"), pos_casa.x+7.55366500, pos_casa.y-0.25457100, pos_casa.z+1.33009200, false, false, false)
      local pants2 = CreateObject(GetHashKey("V_16_Ap_Mid_Pants5"), pos_casa.x+7.76753200, pos_casa.y+3.00476500, pos_casa.z+1.33052800, false, false, false)
      local hairdryer = CreateObject(GetHashKey("v_club_vuhairdryer"), pos_casa.x+8.12616000, pos_casa.y-2.50562000, pos_casa.z+1.96009390, false, false, false)
      FreezeEntityPosition(dt,true)
      FreezeEntityPosition(mpmid01,true)
      FreezeEntityPosition(mpmid09,true)
      FreezeEntityPosition(mpmid07,true)
      FreezeEntityPosition(mpmid03,true)
      FreezeEntityPosition(midData,true)
      FreezeEntityPosition(glow,true)
      FreezeEntityPosition(curtins,true)
      FreezeEntityPosition(mpmid13,true)
      FreezeEntityPosition(mpcab,true)
      FreezeEntityPosition(mpdecal,true)
      FreezeEntityPosition(mpdelta,true)
      FreezeEntityPosition(couch,true)
      FreezeEntityPosition(chair,true)
      FreezeEntityPosition(chair2,true)
      FreezeEntityPosition(plant,true)
      FreezeEntityPosition(lamp,true)
      FreezeEntityPosition(fridge,true)
      FreezeEntityPosition(micro,true)
      FreezeEntityPosition(sideBoard,true)
      FreezeEntityPosition(bedSide,true)
      FreezeEntityPosition(plant2,true)
      FreezeEntityPosition(table,true)
      FreezeEntityPosition(tv,true)
      FreezeEntityPosition(plant3,true)
      FreezeEntityPosition(chair3,true)
      FreezeEntityPosition(lampStand,true)
      FreezeEntityPosition(chair4,true)
      FreezeEntityPosition(chair5,true)
      FreezeEntityPosition(chair6,true)
      FreezeEntityPosition(plant4,true)
      FreezeEntityPosition(storage2,true)
      FreezeEntityPosition(basket,true)
      FreezeEntityPosition(wardrobe,true)
      FreezeEntityPosition(wardrobe2,true)
      FreezeEntityPosition(table2,true)
      FreezeEntityPosition(lamp3,true)
      FreezeEntityPosition(laundry,true)--
      FreezeEntityPosition(beddelta,true)
      FreezeEntityPosition(bed,true)
      FreezeEntityPosition(beddecal,true)
      FreezeEntityPosition(tapeplayer,true)
      FreezeEntityPosition(basket7,true)
      FreezeEntityPosition(basket6,true)
      FreezeEntityPosition(basket8,true)
      FreezeEntityPosition(basket9,true)
      SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
      SetEntityHeading(couch,GetEntityHeading(couch)-90)
      SetEntityHeading(chair,GetEntityHeading(chair)+Rotazione(0.28045480))
      SetEntityHeading(chair2,GetEntityHeading(chair2)+Rotazione(0.3276100))
      SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
      SetEntityHeading(micro,GetEntityHeading(micro)-90)
      SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
      SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
      SetEntityHeading(tv,GetEntityHeading(tv)+90)
      SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
      SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
      SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
      SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
      SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
      SetEntityHeading(storage,GetEntityHeading(storage)+180)
      SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
      SetEntityHeading(table2,GetEntityHeading(table2)+90)
      SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
      SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)
      FreezeEntityPosition(PlayerPedId(),false)
      Nui = true
      daiallerta({x = pos_casa.x, y = pos_casa.y, z = pos_casa.z})
    else
      print('Errore '..tostring(building)..'')
    end
end

function Rotazione(input)
	return 360/(10*input)
end

local disturbance = 1

function daiallerta(pos_casa)
    Citizen.CreateThread(function()
        while true do
            local wait = 500
            --local disturbance = 10
            if Nui then
                wait = 5
                if IsPedShooting(PlayerPedId()) then
                    disturbance = 100
                end
                TriggerEvent("wolf_development:avvia", math.ceil(disturbance))
                if GetEntitySpeed(GetPlayerPed(-1)) > 1.65 then
                    disturbance = disturbance + 0.5
                end
                if GetEntitySpeed(GetPlayerPed(-1)) < 1 then
                    disturbance = disturbance - 0.05
                end
                if disturbance >= 80 then
                    AvvisoPolizia({x = pos_casa.x, y = pos_casa.y, z = pos_casa.z})
                end
            else
                return
            end
            Citizen.Wait(wait)
        end
    end)
end

function progress(k,t)
    if Config.rprogress then
        exports.rprogress:Start(k, t)
    else
        exports['progressBars']:startUI(t, k)
        Citizen.Wait(t)
    end
end

function AvvisoPolizia(pos_casa)
    SetEntityCoords(PlayerPedId(), pos_casa.x, pos_casa.y, pos_casa.z+50)
    HouseRobb = true
    Rapinando = false
    cercaogg1 = false
    cercaogg2 = false
    cercaogg3 = false
    cercaogg4 = false
    cercaogg5 = false
    Nui = false
    RemoveBlip(bliprapina)
    TriggerEvent("wolf_development:stoppa")
    local giocatore = GetEntityCoords(PlayerPedId(-1))
    TriggerServerEvent('wolf_development:allertapolice', 1, giocatore)
end

RegisterNetEvent('wolf_development:clientpolice')
AddEventHandler('wolf_development:clientpolice',function(giocatore)
  if PlayerData.job.name == Config.Police.job then
    ESX.ShowNotification(Lang.allerta2) 
    RemoveBlip(blipRobbery)
    blipRobbery = AddBlipForCoord(giocatore)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
    Wait(60000)
    RemoveBlip(blipRobbery)
  end
end)