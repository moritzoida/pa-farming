------------>Project Alpha<--------------
----->https://discord.gg/EKyPk4QbgD<-----

local ESX = exports['es_extended']:getSharedObject()
local farming = false
local blips = {}

local disabledPoints = {}

local Locale = Config.Locale[Config.Language] or Config.Locale["de"]

CreateThread(function()
    for farmKey, farmData in pairs(Config.Farms) do
        if farmData.blip and farmData.blip.show and farmData.locations[1] then
            local loc = farmData.locations[1]
            local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
            SetBlipSprite(blip, farmData.blip.sprite or 1)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, farmData.blip.scale or 0.8)
            SetBlipColour(blip, farmData.blip.color or 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(farmData.label or "Farm")
            EndTextCommandSetBlipName(blip)
            table.insert(blips, blip)
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearPoint = nil
        local nearFarmKey = nil
        local nearLocIndex = nil

        for farmKey, farmData in pairs(Config.Farms) do
            for i, loc in ipairs(farmData.locations) do
                local isDisabled = disabledPoints[farmKey] == i and farmData.disableAfterHarvest

                if not isDisabled then
                    local dist = #(playerCoords - loc)
                    if dist < 10.0 then
                        sleep = 0
                        local markerType = farmData.marker and farmData.marker.type or 1
                        local scale = farmData.marker and farmData.marker.scale or vector3(1.5, 1.5, 0.5)
                        local color = farmData.marker and farmData.marker.color or {r = 0, g = 255, b = 0, a = 100}

                        DrawMarker(
                            markerType,
                            loc.x, loc.y, loc.z - 1.0,
                            0, 0, 0,
                            0, 0, 0,
                            scale.x, scale.y, scale.z,
                            color.r, color.g, color.b, color.a,
                            false, false, 2, false, nil, nil, false
                        )

                        if dist < 1.5 and not farming then
                            nearPoint = loc
                            nearFarmKey = farmKey
                            nearLocIndex = i

                            ShowHelpNotification(Locale.helpText)
                        end
                    end
                end
            end
        end

        if nearPoint and IsControlJustReleased(0, 38) and not farming then
            farming = true
            StartFarming(nearFarmKey, nearLocIndex)
        end

        Wait(sleep)
    end
end)

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function StartFarming(farmKey, locIndex)
    local farmData = Config.Farms[farmKey]
    local playerPed = PlayerPedId()

    if farmData.animation then
        RequestAnimDict(farmData.animation.dict)
        while not HasAnimDictLoaded(farmData.animation.dict) do
            Wait(100)
        end
        TaskPlayAnim(playerPed, farmData.animation.dict, farmData.animation.name, 8.0, -8.0, -1, farmData.animation.flag or 49, 0, false, false, false)
    end

    local patterns, keys

    if farmData.difficulty == "easy" then
        patterns = {'easy', 'easy', 'medium'}
        keys = {'w', 'a', 's', 'd'}
    elseif farmData.difficulty == "medium" then
        patterns = {'medium', 'medium', 'hard'}
        keys = {'w', 'a', 's', 'd'}
    elseif farmData.difficulty == "hard" then
        patterns = {'hard', 'hard', 'veryhard'}
        keys = {'w', 'a', 's', 'd', 'q', 'e'}
    else
        patterns = {'easy', 'easy', 'medium'}
        keys = {'w', 'a', 's', 'd'}
    end

    local success = lib.skillCheck(patterns, keys)

    if farmData.animation then
        StopAnimTask(playerPed, farmData.animation.dict, farmData.animation.name, 1.0)
    end

    if success then
        local amount = farmData.amount
        local giveAmount = amount
        if type(amount) == "table" and amount.min and amount.max then
            giveAmount = math.random(amount.min, amount.max)
        end

        TriggerServerEvent('my_farm:giveItem', farmData.item, giveAmount)
        ESX.ShowNotification(string.format(Locale.success, giveAmount, farmData.item))

        if farmData.disableAfterHarvest then
            for key, idx in pairs(disabledPoints) do
                if key ~= farmKey then
                    disabledPoints[key] = nil
                end
            end
            disabledPoints[farmKey] = locIndex
        end
    else
        ESX.ShowNotification(Locale.failure)
    end

    farming = false
end

print("A FiveM Farming Script")
print("Version: 1.0.4")
print("Autor: Project Alpha - moritzoida")
