function openGui(percent)
    guiEnabled = true
    local msg = "Livello Allerta"
    if percent > 80 then
        msg = "Allarmato"
    elseif percent > 60 then
        msg = "Insicuro"
    elseif percent > 30 then
        msg = "Tranquillo"
    end
    if percent == 0 then
        return
    end
    SendNUIMessage({runProgress = true, Length = percent, Task = msg})
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

local lastmessage = false
RegisterNetEvent("wolf_development:avvia")
AddEventHandler("wolf_development:avvia", function(percent)
    if not lastmessage then
        lastmessage = true
        openGui(percent)
        Citizen.Wait(500)
        lastmessage = false
    end      
end)

RegisterNetEvent("wolf_development:stoppa")
AddEventHandler("wolf_development:stoppa", function()
    TriggerEvent("wolf_development:avvia", 0.01)
    closeGui()
end)