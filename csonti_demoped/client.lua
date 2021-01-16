ESX = nil
loaded = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
		PlayerData = ESX.GetPlayerData()
    end
    loaded = true
    TriggerServerEvent("david_duty:playerConnected")
end)



config = {
    {drMiker, "s_m_m_doctor_01", "[~g~E~w~] Dr Mike", vector3(108.31,-1003.50,28.40), 180.50, "WORLD_HUMAN_CLIPBOARD", false, "csonti_demoped:mike"},
    {agentKarl, "s_m_m_fibsec_01", "[~g~E~w~] Agent Karl", vector3(108.31,-1008.50,28.40), 180.50, "WORLD_HUMAN_COP_IDLES", false, "csonti_demoped:karl"},
}

Citizen.CreateThread(function()
    while not loaded do
        Citizen.Wait(200)
    end

    while true do
        Citizen.Wait(200)

        for k,v in ipairs(config) do
            if not DoesEntityExist(v[1]) then
                RequestModel(v[2])

                while not HasModelLoaded(v[2]) do
                    Citizen.Wait(200)
                end

                config[k][1] = CreatePed(4, v[2], v[4].x,  v[4].y, v[4].z, v[5])
                SetEntityAsMissionEntity(config[k][1])

                SetBlockingOfNonTemporaryEvents(config[k][1] , true)

                PlaceObjectOnGroundProperly(config[k][1])

                FreezeEntityPosition(config[k][1], true)
                SetEntityInvincible(config[k][1], true)

                TaskStartScenarioInPlace(config[k][1], v[6])    

                SetModelAsNoLongerNeeded(v[2]) 
            end

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v[4].x,  v[4].y, v[4].z)
            
            if dist < 3 then
                v[7] = true
            else
                v[7] = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in ipairs(config) do
            if v[7] then
                ESX.Game.Utils.DrawText3D({x=v[4].x, y=v[4].y, z=v[4].z+2.0}, v[3], 1.0)
                if IsControlJustPressed(0, 38) then
                    TriggerEvent(v[8])
                end
            end
        end
    end
end)



RegisterNetEvent("csonti_demoped:mike")
AddEventHandler("csonti_demoped:mike", function()
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-comment"></i><span style=\"color:white\">  <b>{0}</b>: {1}</span></div>',
        args = {"Mike", "Szia mizu? Mike vagyok!"}
        })
end)


RegisterNetEvent("csonti_demoped:karl")
AddEventHandler("csonti_demoped:karl", function()
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-comment"></i><span style=\"color:white\">  <b>{0}</b>: {1}</span></div>',
        args = {"Karl", "Neked csak Karl Ugynok!"}
        })
end)