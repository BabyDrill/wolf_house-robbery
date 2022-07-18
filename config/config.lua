---------------| Developed by BabyDrill#7768 |---------------
Config = {
    
    ESX = {
        enable = true,
        trigger = "esx:getSharedObject"
    },

    Lockpick_Item = "lockpick",--NOME ITEM PER IRROMPERE IN CASA

    rprogress = true,--Se mettete true userete l'rprogress e se mettete false userete il progressBars

    Police = {
        job = "police",--JOB POLIZIA
        house_robbery = 0--NUMERO MINIMO DI POLIZIOTTI
    },

    Tempo = 20 --TEMPO TRA 1 RAPINA E L'ALTRA E VIENE CONTATA IN MINUTI

}

Config.Marker = {
    lester = {
        id = 20,
        key = 'E',
        distance = 5,
        colour = { r = 209, b = 255, g = 20 },
        scale = vector3(0.5,0.5,0.5)
    },
    house_robbery = {
        id = 20,
        key = 'E',
        distance = 5,
        colour = { r = 209, b = 255, g = 20 },
        scale = vector3(0.5,0.5,0.5)
    }
}

Config.House = {--TUTTE LE CASE 
    [1] = { x = -762.09967041016, y = 430.82369995117, z = 100.19686889648 },
    [2] = { x = -1405.6087646484, y = 526.85473632812, z = 123.83126068115 },
    [3] = { x = -1828.0633544922, y = 311.84631347656, z = 89.711395263672 },
    [4] = { x = -1019.4428100586, y = 719.25042724609, z = 163.99610900879 },
    [5] = { x = -1056.1793212891, y = 761.66149902344, z = 167.31648254395 },
    [6] = { x = -999.03582763672, y = 816.52996826172, z = 173.04965209961 },
    [7] = { x = -912.35015869141, y = 777.62664794922, z = 187.01136779785 },
    [8] = { x = -559.54290771484, y = 664.07672119141, z = 145.45698547363 },
    [9] = { x = -580.52691650391, y = 491.91253662109, z = 108.90299224854 },
    [10] = { x = -595.69769287109, y = 393.25595092773, z = 101.88248443604 }
} 

Config.Lester = {
    marker = { x = 1275.2830810547, y = -1710.6309814453, z = 54.771480560303 },
    ped = { x = 1275.7313232422, y = -1710.3173828125, z = 53.771446228027, h = 120.0, id = 0xB594F5C3 }
}

Config.OggettidaTrovare = {---PRENDETE ESEMPIO E CREATE TUTTI GLI ITEM CHE VOLETE PRENDENDO ESEMPIO
    [1] = {id = "money", label = 'Contante', quantity = math.random(2300, 14500), chance = 5},
    [2] = {id = "black_money", label = 'Soldi Sporchi', quantity = math.random(2300, 14500), chance = 10},
    [3] = {id = "item", name = 'anello', label = 'Anello', quantity = math.random(1, 2), chance = 2},
    [4] = {id = "item", name = 'rolex', label = 'Rolex', quantity = math.random(1, 2), chance = 1},
    [5] = {id = "item", name = 'collana', label = 'Collana', quantity = math.random(1, 20), chance = 5},
    [6] = {id = "null", chance = 40}
}

Lang = {
    ["lester"] = "Premi [~r~E~w~] per parlare con Lester",
    ["house"] = "Premi [~r~E~w~] per rapinare la casa!",
    ["esci_rapina"] = "Premi [~r~E~w~] per uscire dalla casa!",
    ["blip_lester"] = "Lester",
    ["rapinaon"] = "Hai già startato una rapina!",
    ["police"] = "Polizia insufficiente, riprova più tardi!",
    ["veicolo"] = "Devi scendere dal veciolo per entrare in casa!",
    ["progressbar"] = "Organizzando Colpo",
    ["house_blip"] = "Casa da Rubare",
    ["start_robbery"] = "Lester ti ha trovato una casa da rapinare! Guarda il GPS",
    ["lockpick"] = "Devi avere un Grimaldello per irrompere in casa!",
    ["scassinando"] = "Scassinando Serratura",
    ["door_broke"] = "Hai scassinato la porta e sei entrato in casa!",
    ["rapinaoff"] = "Hai già scassinato questa casa!",
    ["cercaoff"] = "Hai già cercato in questo posto!",
    ["cercandon"] = "Cercando",
    ["allerta"] = "Cammina lentamente per non allertare i poliziotti",
    ["allerta1"] = "Sei stato rintracciato dalla polizia! SCAPPA!!!",
    ["allerta2"] = "Allarme Furto in casa attivato! Vai alla posizione sul gps!",
    ["null"] = "Non hai trovato nulla! :(",
    ["aspetta"] = "Hai startato recentemente un furto in casa aspetta prima di farne un'altro!"
}

---------------| Developed by BabyDrill#7768 |---------------