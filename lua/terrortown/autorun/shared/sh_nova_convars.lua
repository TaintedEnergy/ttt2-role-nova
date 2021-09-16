-- replicated convars have to be created on both client and server
CreateConVar("ttt_nova_min_explode_time", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt_nova_max_explode_time", 180, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_nova_convars", function(tbl)
	tbl[ROLE_NOVA] = tbl[ROLE_NOVA] or {}

	table.insert(tbl[ROLE_NOVA], {
		cvar = "ttt_nova_min_explode_time",
		slider = true,
		min = 0,
		max = 6000,
		decimal = 0,
		desc = "ttt_nova_min_explode_time (def. 30)"
	})
	table.insert(tbl[ROLE_NOVA], {
		cvar = "ttt_nova_max_explode_time",
		slider = true,
		min = 0,
		max = 6000,
		decimal = 0,
		desc = "ttt_nova_min_explode_time (def. 180)"
	})
end)
