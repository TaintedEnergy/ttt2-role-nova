if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_nova")
end


function ROLE:PreInitialize()
	self.color                      = Color(255, 196, 0, 255)

	self.abbr                       = "nova"
	self.surviveBonus               = 0
	self.score.killsMultiplier      = 2
	self.score.teamKillsMultiplier  = -8
	self.unknownTeam                = true

	self.defaultTeam                = TEAM_INNOCENT

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then
	-- Set kill-explode timer
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		local explodeTime = math.random( GetConVar("ttt_nova_min_explode_time"):GetInt(), GetConVar("ttt_nova_max_explode_time"):GetInt() )
		timer.Create("nova-kill-explode" .. ply:SteamID64(), explodeTime, 1, function()
			if not IsValid(ply) then return end
			ply:Kill()
		end)
	end

	-- Remove kill-explode timer
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		timer.Remove("nova-kill-explode" .. ply:SteamID64())
	end

	hook.Add("TTT2PostPlayerDeath", "NovaDied", function(ply)
		if not IsValid(ply) then return end
		if ply:GetSubRole() ~= ROLE_NOVA then return end

		local explode = ents.Create("env_explosion")
		explode:SetPos(ply:GetPos())
		explode:SetOwner(ply)
		explode:Spawn()
		explode:SetKeyValue("iMagnitude", "150")
		explode:Fire("Explode", 0, 0)
		explode:EmitSound("ambient/explosions/explode_4.wav", 400, 400)

		timer.Remove("nova-kill-explode" .. ply:SteamID64())
	end)

	hook.Add("TTTOnCorpseCreated", "NovaCorpseCreated", function (corpse, ply) 
		if not IsValid(ply) then return end
		if ply:GetSubRole() ~= ROLE_NOVA then return end
		corpse:Remove()
	end)
end
