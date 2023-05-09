util.keep_running()

-- minified lib for bitwise operations
local v0={};local v1={};v0.Set=function(v12,v13,v14)return v13 | (1<<v14) ;end;v0.Clear=function(v15,v16,v17)return v16 &  ~(1<<v17) ;end;v0.Toggle=function(v18,v19,v20)return v19~(1<<v20) ;end;v0.Check=function(v21,v22,v23)return (v22 & (1<<v23))~=0 ;end;v0.Get=function(v24,v25,v26)return v25 & v26 ;end;v1.Set=function(v27,v28,v29)return v28 | v29 ;end;v1.Clear=function(v30,v31,v32)return v31 &  ~v32 ;end;v1.Toggle=function(v33,v34,v35)return v34~v35 ;end;v1.Check=function(v36,v37,v38)return (v37 & v38)~=0 ;end;v1.Get=function(v39,v40,v41)return v40 & v41 ;end;
local Bit = v0
local BitMask = v1

local root = menu.my_root()
local shadow_root = menu.shadow_root()
local SCRIPT_VERSION <const> = "1.1.1"
local update_button = nil

local ScriptGlobal = memory.script_global
local ReadInt = memory.read_int
local ReadByte = memory.read_byte
local ReadShort = memory.read_short
local WriteInt = memory.write_int
local WriteByte = memory.write_byte
local ReadString = memory.read_string
local ref_by_rel_path = menu.ref_by_rel_path
local get_label_text = util.get_label_text
local reverse_joaat = util.reverse_joaat
local get_user_vehicle_as_pointer = entities.get_user_vehicle_as_pointer
local get_model_hash = entities.get_model_hash
local delete_by_pointer = entities.delete_by_pointer
local get_all_vehicles_as_pointers = entities.get_all_vehicles_as_pointers
local get_position = entities.get_position
local fs = filesystem

async_http.init("sodamnez.xyz", "/MorsMutual/index.php", function(body, headers, status_code)
    if status_code == 200 then
        if body ~= SCRIPT_VERSION then
            update_button = shadow_root:action("Update", {}, "Update the script", function()
                async_http.init("sodamnez.xyz", "/MorsMutual/MorsMutual.lua", function(body, headers, status_code)
                    if status_code == 200 then
                        local file <close> = assert(io.open(fs.scripts_dir() .. "/" .. SCRIPT_RELPATH, "wb"))
                        file:write(body)
                        file:close()

                        util.toast("Update successfully, restarting ...")
                        util.restart_script()
                    else
                        util.toast("Failed to update: " .. status_code)
                    end
                end)

                async_http.dispatch()
            end)
            ref_by_rel_path(root, "Stop Script"):attachAfter(update_button)
        end
    else
        util.toast("Failed to check for updates: " .. status_code)
    end
end)

async_http.dispatch()

local PV_SLOT <const> = 2359296 + 1 + (0 * 5568) + 681 + 2

local function GetPvSlot()
    return ReadShort(ScriptGlobal(PV_SLOT))
end

local function GetPersonalVehicleData(slot=0)
    local pv_slot = ScriptGlobal(PV_SLOT)
    slot = slot ?? ReadInt(ScriptGlobal(PV_SLOT))

    return ScriptGlobal(1586468 + 1 + (slot * 142))
end

local function ClaimVehicle(slot, respawn=false)
    local data = GetPersonalVehicleData(slot)
    local bitfield = ReadInt(data + 0x338)

    if BitMask:Check(bitfield, 0x42) then
        bitfield = BitMask:Clear(bitfield, 0x23)
        bitfield = respawn ? (Bit:Set(bitfield, 2)) : (BitMask:Set(bitfield, 0x5))
        WriteInt(data + 0x338, bitfield)
    end
end

local function ToggleOwnerCheck(state)
    WriteByte(ScriptGlobal(78558), state ? 1 : 0)
end

--[[BOOL (bool)]] local function IsPedInAnyVehicle(--[[Ped (int)]] ped,--[[BOOL (bool)]] atGetIn)native_invoker.begin_call()native_invoker.push_arg_int(ped)native_invoker.push_arg_bool(atGetIn)native_invoker.end_call_2(0x997ABD671D25CA0B)return native_invoker.get_return_value_bool()end
--[[Vehicle (int)]] local function GetVehiclePedIsIn(--[[Ped (int)]] ped,--[[BOOL (bool)]] includeLastVehicle)native_invoker.begin_call()native_invoker.push_arg_int(ped)native_invoker.push_arg_bool(includeLastVehicle)native_invoker.end_call_2(0x9A9112A0FE9A4713)return native_invoker.get_return_value_int()end
--[[Hash (int)]] local function GetEntityModel(--[[Entity (int)]] entity)native_invoker.begin_call()native_invoker.push_arg_int(entity)native_invoker.end_call_2(0x9F47B058362C84B5)return native_invoker.get_return_value_int()end
--[[Hash (int)]] local function NetworkHashFromPlayerHandle(--[[Player (int)]] player)native_invoker.begin_call()native_invoker.push_arg_int(player)native_invoker.end_call_2(0xBC1D768F2F5D6C05)return native_invoker.get_return_value_int()end
--[[int]] local function DecorGetInt(--[[Entity (int)]] entity,--[[string]] propertyName)native_invoker.begin_call()native_invoker.push_arg_int(entity)native_invoker.push_arg_string(propertyName)native_invoker.end_call_2(0xA06C969B02A97298)return native_invoker.get_return_value_int()end
--[[BOOL (bool)]] local function DecorSetInt(--[[Entity (int)]] entity,--[[string]] propertyName,--[[int]] value)native_invoker.begin_call()native_invoker.push_arg_int(entity)native_invoker.push_arg_string(propertyName)native_invoker.push_arg_int(value)native_invoker.end_call_2(0x0CE3AA5E1CA19E10)return native_invoker.get_return_value_bool()end
--[[void]] local function SetVehicleIsStolen(--[[Vehicle (int)]] vehicle,--[[BOOL (bool)]] isStolen)native_invoker.begin_call()native_invoker.push_arg_int(vehicle)native_invoker.push_arg_bool(isStolen)native_invoker.end_call_2(0x67B2C79AA7FF5738)end
--[[Interior (int)]] local function GetInteriorFromEntity(--[[Entity (int)]] entity)native_invoker.begin_call()native_invoker.push_arg_int(entity)native_invoker.end_call_2(0x2107BA504071A6BB)return native_invoker.get_return_value_int()end
--[[Vector3 (vector3)]] local function GetOffsetFromEntityInWorldCoords(--[[Entity (int)]] entity,--[[float]] offsetX,--[[float]] offsetY,--[[float]] offsetZ)native_invoker.begin_call()native_invoker.push_arg_int(entity)native_invoker.push_arg_float(offsetX)native_invoker.push_arg_float(offsetY)native_invoker.push_arg_float(offsetZ)native_invoker.end_call_2(0x1899F328B0E12848)return native_invoker.get_return_value_vector3()end

root:divider("Mors Mutual")
root:toggle("Respawn Next To You", {}, "Respawns your vehicle next to you after it is claimed", function(state) end)
root:divider("")

root:action("Claim All Personal Vehicles", {"morsclaimall"}, "Claim all your personal vehicles from mors mutual or the impound", function()
    for slot = 0, 415 do
        ClaimVehicle(slot, ref_by_rel_path(root, "Respawn Next To You").value)
    end
end)

root:action("Claim Personal Vehicle", {"morsclaimactive"}, "Claim your active personal vehicle", function()
    ClaimVehicle(GetPvSlot(), ref_by_rel_path(root, "Respawn Next To You").value)
end)

root:action("Add Temp Insurance", {"morstempinsured"}, "Temporarily add insurance to your vehicle", function()
    local data = GetPersonalVehicleData(GetPvSlot())
    local bitfield = ReadInt(data + 0x338)

    if Bit:Check(bitfield, 2) then
        if not ref_by_rel_path(root, "Auto Add Temp Insurance").value then
            local model = get_label_text(reverse_joaat(ReadInt(data + 0x210)))
            util.toast(T"Your " .. model .. T" is already insured")
        end
    else
        bitfield = BitMask:Set(bitfield, 0x400904)
        WriteInt(data + 0x338, bitfield)
        util.toast(T"WARNING: You need to goto ls customs and change any upgrade for this to stick")
    end
end)

root:action("Request Personal Vehicle", {}, "Spawns your personal vehicle near you", function()
    local data = GetPersonalVehicleData(GetPvSlot())
    local bitfield = ReadInt(data + 0x338)

    if Bit:Check(bitfield, 0) then
        WriteInt(data + 0x338, Bit:Clear(bitfield, 0))
        util.yield(350)
    else
        WriteInt(data + 0x338, Bit:Set(bitfield, 0))
    end

    WriteInt(data + 0x338, Bit:Set(bitfield, 0))
end)

root:divider("")

root:toggle_loop("Auto Claim All", {"morsautoclaimall"}, "Automatically claim all your vehicles", function()
    ref_by_rel_path(root, "Claim All Personal Vehicles"):trigger()
end)

root:toggle_loop("Auto Claim Personal Vehicle", {"morsautoclaimactive"}, "Automatically claim your active personal vehicle", function()
    ref_by_rel_path(root, "Claim Personal Vehicle"):trigger()
end)

root:toggle_loop("Auto Add Temp Insurance", {"morsautotempinsured"}, "Automatically add temp insurance to your vehicle", function()
    ref_by_rel_path(root, "Add Temp Insurance"):trigger()
end)

root:divider("")

root:action("Gift Vehicle", {"giftself"}, "Improved version of Stand's native vehicle gifting option", function()
    local ped = players.user_ped()
    
    if not IsPedInAnyVehicle(ped, false) then
        return util.toast("You are not in a vehicle")
    end

    local veh = GetVehiclePedIsIn(ped, false)
    local start = os.time() + 30

    if veh == 0 or veh == nil then
        return
    end

    local spawned = reverse_joaat(GetEntityModel(veh))
    local nethash = NetworkHashFromPlayerHandle(players.user())

    local bitset = DecorSetInt(veh, "MPBitset", DecorGetInt(veh, "MPBitset") | 0x1000008)
    ToggleOwnerCheck(false)
    for {"Player_Vehicle", "Veh_Modded_By_Player"} as decor do DecorSetInt(veh, decor, nethash) end
    for {"Previous_Owner", "PV_Slot"} as decor do DecorSetInt(veh, decor, 0) end
    SetVehicleIsStolen(veh, false)

    local interior = GetInteriorFromEntity(ped)

    repeat
        if os.time() >= start then
            ToggleOwnerCheck(true)
            return util.toast("Failed to gift vehicle, you took too long")
        end

        interior = GetInteriorFromEntity(ped)
        util.yield_once()
    until interior ~= 0

    ToggleOwnerCheck(true)

    repeat
        interior = GetInteriorFromEntity(ped)
        util.yield_once()
    until interior == 0

    util.yield(2000)

    local player_veh = get_user_vehicle_as_pointer()

    for get_all_vehicles_as_pointers() as entity do
        local model = reverse_joaat(get_model_hash(entity))

        if model:find(spawned) then
            local veh_pos = get_position(entity)
            local ped_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)

            if veh_pos:distance(ped_pos) < 100.0 then
                if not IsPedInAnyVehicle(ped, false) then
                    delete_by_pointer(entity)
                else
                    if entity ~= player_veh then
                        delete_by_pointer(entity)
                    end
                end
            end
       end
    end
end)
