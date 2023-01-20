plib.Require( 'entity_lights' )

local entity_lights = entity_lights

-- Player Color
entity_lights.Register('weapon_physgun', function( wep, light )
    light:SetBrightness( 1 )
end,
function( wep, light, ply )
    if ply:IsPlayer() then
        local weaponColor = ply:GetWeaponColor() * 255
        light:SetColorUnpacked( weaponColor[1], weaponColor[2], weaponColor[3] )
    end
end)

-- Orange
entity_lights.Register('env_rockettrail', function( ent, light )
    light:SetColorUnpacked( 255, 100, 0 )
    light:SetBrightness( 2 )
    light:SetSize( 256 )
end)

entity_lights.Register('env_sprite', function( ent, light )
    local parent = ent:GetParent()
    if IsValid( parent ) then
        local class = parent:GetClass()
        if (class == 'crossbow_bolt') then
            light:SetColorUnpacked( 255, 100, 0 )
            light:SetBrightness( 0.25 )
        elseif (class == 'combine_mine') then
            light:SetColor( ent:GetColor() )
            light:SetBrightness( 1 )
        elseif (class == 'npc_grenade_frag') then
            light:SetColorUnpacked( 255, 0, 0 )
            light:SetBrightness( 0.5 )
        elseif (class == 'npc_manhack') then
            light:SetColorUnpacked( 255, 0, 0 )
            light:SetBrightness( 0.25 )
            light:SetSize( 48 )
        elseif (class == 'npc_cscanner') then
            light:SetColorUnpacked( 255, 255, 255 )
            light:SetBrightness( 0.5 )
            light:SetSize( 64 )
        else
            light:Remove()
            return
        end

        return
    end

    light:Remove()
end)

entity_lights.Register('weapon_physcannon', function( wep, light )
    light:SetColorUnpacked( 255, 200, 0 )
    light:SetBrightness( 1 )
end)

entity_lights.Register('item_suitcharger', function( ent, light )
    light:SetColorUnpacked( 255, 200, 0 )
    light:SetBrightness( 0.5 )
end, function( ent, light )
    light:SetAlpha( (1 - ent:GetCycle()) * 255 )
end)

entity_lights.Register('item_ammo_ar2_altfire', function( ent, light )
    light:SetColorUnpacked( 255, 200, 0 )
    light:SetBrightness( 0.5 )
end)

entity_lights.Register('weapon_crossbow', function( wep, light )
    light:SetColorUnpacked( 255, 200, 0 )
    light:SetBrightness( 0.5 )
end,
function( wep, light )
    if (wep:Clip1() == 0) then
        if (light:GetAlpha() == 0) then return end
        light:SetAlpha( 0 )
    elseif (light:GetAlpha() ~= 255) then
        light:SetAlpha( 255 )
    end
end)

-- Green
entity_lights.Register('item_healthkit', function( ent, light )
    light:SetColorUnpacked( 60, 255, 0 )
    light:SetBrightness( 0.25 )
end)

entity_lights.Register('weapon_medkit', function( ent, light )
    light:SetColorUnpacked( 60, 255, 0 )
    light:SetBrightness( 1 )
end)

entity_lights.Register('item_healthvial', function( ent, light )
    light:SetColorUnpacked( 60, 255, 0 )
    light:SetBrightness( 0.5 )
end)

-- Blue
entity_lights.Register('npc_rollermine', function( npc, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.5 )
end)

entity_lights.Register('weapon_striderbuster', function( npc, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.25 )
    light:SetSize( 32 )
end)

entity_lights.Register('item_battery', function( ent, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.5 )
end)

entity_lights.Register('item_ammo_ar2', function( ent, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.5 )
end)

entity_lights.Register('item_ammo_ar2_large', function( ent, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.5 )
end)

entity_lights.Register('item_healthcharger', function( ent, light )
    light:SetColorUnpacked( 0, 255, 255 )
    light:SetBrightness( 0.5 )
end, function( ent, light )
    light:SetAlpha( (1 - ent:GetCycle()) * 255 )
end)

-- Red
entity_lights.Register('grenade_helicopter', function( ent, light )
    light:SetColorUnpacked( 255, 0, 0 )
    light:SetBrightness( 0.5 )
end)

-- White
entity_lights.Register('prop_combine_ball', function( ent, light )
    light:SetColorUnpacked( 255, 255, 255 )
    light:SetBrightness( 1 )
    light:SetSize( 128 )
end)
