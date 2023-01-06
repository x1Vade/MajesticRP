

DecorRegister("Vehicle-Identifier", 3)

function SetVehicleIdentifier(vehicle, id)
	if not DoesEntityExist(vehicle) then return end
	if not id or type(id) ~= "number" then return end

	Sync.DecorSetInt(vehicle, "Vehicle-Identifier", id)
end

function SetVehiclePlate(vehicle, plate)
	if not DoesEntityExist(vehicle) then return end
	if not plate or type(plate) ~= "string" then return end

	SetVehicleNumberPlateText(vehicle, plate)
end

function GetVehicleIdentifier(vehicle)
    if not DoesEntityExist(vehicle) then
		return false
	end

	if not DecorExistOn(vehicle, "Vehicle-Identifier") then
		return false
	end

	return DecorGetInt(vehicle, "Vehicle-Identifier")
end

function GetVehiclePlate(vehicle)
	if not DoesEntityExist(vehicle) then
		return ""
	end

	local plate = GetVehicleNumberPlateText(vehicle)

	return string.gsub(plate, "%s+", "")
end

function GetVehicleTier(vehicle)
	if not DoesEntityExist(vehicle) then
		return
	end

	local function getField(field)
		return GetVehicleHandlingFloat(vehicle, "CHandlingData", field)
	end

	local model = GetEntityModel(vehicle)
	local isMotorCycle = IsThisModelABike(model)

	local fInitialDriveMaxFlatVel = getField("fInitialDriveMaxFlatVel")
	local fInitialDriveForce = getField("fInitialDriveForce")
	local fDriveBiasFront = getField("fDriveBiasFront")
	local fInitialDragCoeff = getField("fInitialDragCoeff")
	local fTractionCurveMax = getField("fTractionCurveMax")
	local fTractionCurveMin = getField("fTractionCurveMin")
	local fSuspensionReboundDamp = getField("fSuspensionReboundDamp")
	local fBrakeForce = getField("fBrakeForce")

	-- Acceleration: (fInitialDriveMaxFlatVel x fInitialDriveForce)/10
	-- If the fDriveBiasFront is greater than 0 but less than 1, multiply fInitialDriveForce by 1.1.
	local force = fInitialDriveForce
	if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
		force = force * 1.1
	end

	local accel = (fInitialDriveMaxFlatVel * force) / 10

	-- Speed:
	-- ((fInitialDriveMaxFlatVel / fInitialDragCoeff) x (fTractionCurveMax + fTractionCurveMin))/40
	local speed = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
	if isMotorCycle then
	  	speed = speed * 2
	end

	-- Handling:
	-- (fTractionCurveMax + fSuspensionReboundDamp) x fTractionCurveMin
	local handling = (fTractionCurveMax + fSuspensionReboundDamp) * fTractionCurveMin
	if isMotorCycle then
	  	handling = handling / 2
	end

	-- Braking:
	-- ((fTractionCurveMin / fInitialDragCoeff) x fBrakeForce) x 7
	local braking = ((fTractionCurveMin / fInitialDragCoeff) * fBrakeForce) * 7

	-- Overall Performance Bracket:
	-- ((Acceleration x 5) + Speed + Handling + Braking) * 15
	-- X Class: > 1000
	-- S Class: > 650
	-- A Class: > 500
	-- B Class: > 400
	-- C Class: > 325
	-- D Class: =< 325
	local perfRating = ((accel * 5) + speed + handling + braking) * 15
	local vehClass = "F"
	if isMotorCycle then
		vehClass = "M"
	elseif perfRating > 900 then
	  	vehClass = "X"
	elseif perfRating > 700 then
	  	vehClass = "S"
	elseif perfRating > 550 then
	  	vehClass = "A"
	elseif perfRating > 400 then
	  	vehClass = "B"
	elseif perfRating > 325 then
	  	vehClass = "C"
	else
	  	vehClass = "D"
	end

	return vehClass
end

function GetVehicleAfterMarket(vehicle, type)
	if type then
		return nil
	else
		return {}
	end
end


exports("GetVehicleIdentifier", GetVehicleIdentifier)
exports("GetVehiclePlate", GetVehiclePlate)
exports("GetVehicleMetadata", GetVehicleMetadata)
exports("GetVehicleTier", GetVehicleTier)
exports("GetVehicleAfterMarket", GetVehicleAfterMarket)
exports("spawnVehicle", spawnVehicle)