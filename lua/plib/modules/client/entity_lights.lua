plib.Require( 'dynamic_light' )

local CreateDynamicLight = CreateDynamicLight
local isfunction = isfunction
local ArgAssert = ArgAssert
local FrameTime = FrameTime
local math_min = math.min
local math_max = math.max
local IsValid = IsValid
local hook = hook

module( 'entity_lights' )

local registered = {}
function Register( className, init, think, alwaysCastLight )
	ArgAssert( className, 1, 'string' )
	registered[ className ] = {
		['Init'] = init,
		['Think'] = think,
		['AlwaysCastLight'] = alwaysCastLight
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
		local autoAlpha = data.AlwaysCastLight ~= true

		hook.Add('Think', light, function( self )
			local entity = self.Entity
			if IsValid( entity ) then
				if entity:IsWeapon() then
					local ply = entity:GetOwner()
					if IsValid( ply ) then
						local activeWeapon = ply:GetActiveWeapon()
						if IsValid( activeWeapon ) and (activeWeapon:EntIndex() == entity:EntIndex()) then
							if autoAlpha then
								local alpha = self:GetAlpha()
								if (alpha < 255) then
									self:SetAlpha( math_min( alpha + 255 * FrameTime(), 255 ) )
								end
							end

							if (thinkFunc) then
								thinkFunc( entity, self, ply )
							end
						elseif autoAlpha then
							local alpha = self:GetAlpha()
							if (alpha > 0) then
								self:SetAlpha( math_max( 0, alpha - 255 * FrameTime() ) )
							end
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