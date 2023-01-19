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

	local light = CreateDynamicLight()
	light:SetSize( -1 )
	light.Entity = ent

	local initFunc = data.Init
	if isfunction( initFunc ) then
		initFunc( ent, light )
	end

	if IsValid( light ) then
		if (light:GetSize() == -1) then
			light:SetSize( light:GetBrightness() * 64 )
		end

		local thinkFunc = isfunction( data.Think ) and data.Think or nil
		local autoAlpha = data.AutoAlpha ~= true

		hook.Add('Think', light, function( self )
			local entity = self.Entity
			if IsValid( entity ) then
				if entity:IsWeapon() then
					local ply = entity:GetOwner()
					if IsValid( ply ) then
						if (ply:GetActiveWeapon() == entity) then
							if autoAlpha and (self:GetAlpha() ~= 255) then
								self:SetAlpha( 255 )
							end

							if (thinkFunc) then
								thinkFunc( entity, self, ply )
							end
						elseif autoAlpha and (self:GetAlpha() ~= 0) then
							self:SetAlpha( 0 )
						end
					end
				elseif (thinkFunc) then
					thinkFunc( entity, self )
				end

				self:SetPos( entity:LocalToWorld( entity:OBBCenter() ) )
				return
			end

			self:Remove()
		end)
	end
end)