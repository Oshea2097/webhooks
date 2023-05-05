
local SizeX, SizeY = guiGetScreenSize()
local px,py = 1680,1050
local x,y = (SizeX/px), (SizeY/py)

local font1 = dxCreateFont("files/GothaProLig.otf", 25)
local font2 = dxCreateFont("files/GothaProMed.otf", 25)

 if state and getKeyState("lctrl") then
        if button == "a" then
        elseif button == "d" then
        elseif button == "s" then
        end
        return
    end


speedometr = false

function math.lerp(a, b, k)
	local result = a * (1-k) + b * k
	if result >= b then
		result = b
	elseif result <= a then
		result = a
	end
	return result
end

local alpha = 255
local side = true
local pulsing = true

function speedometrs ()
    local veh = getPedOccupiedVehicle(getLocalPlayer()) 
    if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end
    if not driveDistance then lastTick = getTickCount() driveDistance = getElementData ( veh, "driveDistance" ) or 0 end
	local neux, neuy, neuz = getElementPosition(veh)
	local Speed = getVehicleSpeed()
	local car = getPedOccupiedVehicle(localPlayer)
	local vehs = math.floor(getElementSpeed(getPedOccupiedVehicle(getLocalPlayer()), "kmh"))
    
    local cfuel = math.ceil((getElementData(veh,'vehicle:fuel')) or 100)
    local mfuel = (getElementData(veh,'maxFuel') or 100)
    
    if cfuel > 100 then cfuel = 100 end
    if cfuel > 20 then
    end
    local rotation2 = math.lerp(-1,260,cfuel/mfuel)
    if rotation2 <= 150 then pulsing = true else pulsing = false end
    
    if pulsing then
        if side then alpha = alpha + 5 else alpha = alpha -5 end
        if alpha <= 0 then side = true elseif alpha >= 255 then side = false end
        dxDrawImage(SizeX - 345,SizeY - 230, 330, 220,"files/not_benz.png",0,0,0,tocolor(255,0,0,alpha))
    end
	   
	dxDrawImage(SizeX - 345,SizeY - 230, 330, 220, "files/panel.png", 0,0,0 )-- Фон спидометра
	
	dxDrawImage(SizeX - 222,SizeY - 130, 195, 22, "files/arrow.png", Speed,0,0 )-- Стрелка спидометра
	dxDrawImage(SizeX - 290,SizeY - 145, 21, 140, "files/arrow_benz.png", rotation2)-- Стрелка бензина
	
    if ( getVehicleEngineState (veh) == true ) then -- индикатор двигателя
        dxDrawImage(SizeX - 240,SizeY - 34, 22, 16,"files/engineOn.png",0.0,0.0,0.0,tocolor(255,255,255),false)
    else
        dxDrawImage(SizeX - 240,SizeY - 34, 22, 16,"files/engineOff.png",0.0,0.0,0.0,tocolor(255,255,255),false)
    end
    
    if getVehicleOverrideLights ( veh ) ~= 2 then -- индикатор света
        dxDrawImage(SizeX - 210,SizeY - 34, 21, 15,"files/lightOff.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
    else
        dxDrawImage(SizeX - 210,SizeY - 34, 21, 15,"files/lightOn.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
        dxDrawImage(SizeX - 345,SizeY - 230, 330, 220, "files/light.png", 0,0,0 )
    end
    
    dxDrawText(tostring ( getFormatSpeed ( vehs )),SizeX,SizeY - 320, SizeX - 245,SizeY, tocolor(255,255,255,255), 0.8,0.8, font2,"center","center")
	dxDrawText(cfuel.."/"..mfuel.." l.",SizeX,SizeY - 100, SizeX - 210,SizeY, tocolor(255,255,255,255), 0.4,0.4, font2,"right","center")
end
addEventHandler("onClientRender", root, speedometrs)

----------------------------------

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "00" .. unit
    elseif unit < 100 then
        unit = "0" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end

addEventHandler("onClientPlayerVehicleEnter",getRootElement(),function(veh,seat)
	if source == localPlayer then
		altx, alty, altz=getElementPosition(veh)
		lastTick = getTickCount()
		driveDistance = getElementData ( veh, "driveDistance" )
	end
end
)

function getVehicleSpeed()
    if isPedInVehicle(localPlayer) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 120
    end
    return 0
end

