plib.Require( 'dynamic_light' )

local CreateDynamicLight = CreateDynamicLight
local isfunction = isfunction
local ArgAssert = ArgAssert
local IsValid = IsValid
local hook = hook

module( 'entity_lights' )

local registered = {}
function Register( className, init, think, disableAutoAlpha )
    ArgAssert( className, 1, 'string' )
    registered[ className ] = {
        ['Init'] = init,
        ['Think'] = think,
        ['AutoAlpha'] = disableAutoAlpha
    }
end

function UnRegister( className )
    registered[ className ] = nil
end

hook.Add('OnEntityCreated', 'PLib - Dynamic Lights', function( ent )
    local data = registered[ ent:GetClass() ]
    if (data == nil) then return end

    local light = CreateDynamicLight( ent:EntIndex() )
    if IsValid( light ) then
        ent.DynamicLight = light

        local initFunc = data.Init
        if isfunction( initFunc ) then
            initFunc( ent, light )
        end

        if (light:GetSize() == 0) then
            light:SetSize( light:GetBrightness() * 64 )
        end
    end

    local thinkFunc = isfunction( data.Think ) and data.Think or nil
    local autoAlpha = data.AutoAlpha ~= true
    hook.Add('Think', ent, function( self )
        local dLight = self.DynamicLight
        if IsValid( dLight ) then
            if self:IsWeapon() then
                local ply = self:GetOwner()
                if IsValid( ply ) then
                    if (ply:GetActiveWeapon() == self) then
                        if autoAlpha and (dLight:GetAlpha() ~= 255) then
                            dLight:SetAlpha( 255 )
                        end

                        if (thinkFunc) then
                            thinkFunc( self, dLight, ply )
                        end
                    elseif autoAlpha and (dLight:GetAlpha() ~= 0) then
                        dLight:SetAlpha( 0 )
                    end
                end
            elseif (thinkFunc) then
                thinkFunc( self, dLight )
            end

            dLight:SetPos( self:LocalToWorld( self:OBBCenter() ) )
        else
            hook.Remove('Think', self)
        end
    end)

end)

hook.Add('EntityRemoved', 'PLib - Dynamic Lights', function( ent )
    if registered[ ent:GetClass() ] then
        local light = ent.DynamicLight
        if IsValid( light ) then
            light:Remove()
        end
    end
end)
