AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

resource.AddFile("sound/bounty/ching1.wav")
resource.AddFile("sound/bounty/critical.wav")
util.PrecacheSound("bounty/ching1.wav")
util.PrecacheSound("bounty/ching2.wav")
util.PrecacheSound("bounty/critical.wav")
local CashMultiplier = 10

----------------------
-- Round functions. --
----------------------
function GM:CanStartRound( iNum )
	for k,ply in pairs(player.GetAll()) do
		ply:SetTeam(TEAM_MAIN)
		ply:SetRandomClass()
	end
    return true
end

function GM:OnRoundStart( iNum )
	self.BaseClass:OnRoundStart( iNum )
	
	for k,player in pairs( player.GetAll() ) do
		player.bounty = 1
		player.cash   = 0
		player.multiplier = 1
		UpdatePlayerVariables( player )
	end
end

function GM:RoundTimerEnd()
	if ( !GAMEMODE:InRound() ) then return end 
 
	local winner, draw = GAMEMODE:SelectCurrentlyWinningPlayer()
	if draw == 1 then
		GAMEMODE:RoundEndWithResult( -1, "Stalemate!" )
	else
		GAMEMODE:RoundEndWithResult( winner )
	end
end

function GM:CheckPlayerDeathRoundEnd()
	return false
end

function GM:SelectCurrentlyWinningPlayer()
	local winner
	local topscore = 0
	local draw = 1
 
	for k,v in pairs( player.GetAll() ) do
		if v:Team() != TEAM_CONNECTING and v:Team() != TEAM_UNASSIGNED then
			if v.cash > topscore then
				winner = v
				topscore = v.cash
				draw = 0
			elseif v.cash == topscore then
				draw = 1
			end
		end
	end
 
	return winner, draw
end

-----------------------
-- Player functions. --
-----------------------
function GM:PlayerInitialSpawn( ply )
	self.BaseClass:PlayerInitialSpawn( ply )
	
	ply.bounty = 1
	ply.cash   = 0
	ply.multiplier = 1
	UpdatePlayerVariables( ply )
	
	ply:SetTeam(TEAM_MAIN)
	ply:SetRandomClass()
end

function GM:PlayerJoinTeam( ply, teamid )
	self.BaseClass:PlayerJoinTeam( ply, teamid )
	
	if teamid == TEAM_UNASSIGNED then
		ply:SetTeam( TEAM_MAIN )
	end
end

function GM:PlayerDeath( Victim, Weapon, Killer )
	self.BaseClass:PlayerDeath( Victim, Weapon, Killer )

	Killer.bounty = Killer.bounty + 1
	local newCash = math.floor(Victim.bounty * Killer.multiplier * CashMultiplier)
	Killer.cash   = Killer.cash + newCash
	Victim.bounty = 0
	Victim.multiplier = 1
	
	local lastMult = Killer.multiplier
	Killer.multiplier = 1
	if(Killer.bounty >= 2) then Killer.multiplier = 1.5 end
	if(Killer.bounty >= 3) then Killer.multiplier = 2 end
	if(Killer.bounty >= 5) then Killer.multiplier = 3 end
	if(Killer.bounty >= 7) then Killer.multiplier = 4 end
	if(Killer.bounty >= 9) then Killer.multiplier = 5 end
	if(Killer.bounty >= 11) then Killer.multiplier = 6 end
	if(Killer.bounty >= 15) then Killer.multiplier = 10 end
	
	UpdatePlayerVariables( Killer )
	UpdatePlayerVariables( Victim )
	
	local rp = RecipientFilter()     -- Grab a CRecipientFilter object
	rp:AddPlayer( Killer )           -- Send to all players!
	umsg.Start("OnKill", rp)
	umsg.Short(newCash)
	if Killer.multiplier > lastMult then
		umsg.Float(Killer.multiplier)
	else
		umsg.Float(0)
	end
	umsg.End()
	
	Killer:EmitSound("bounty/ching1.wav", 100, 100)
	if( Killer.multiplier > lastMult ) then
		Killer:EmitSound("bounty/critical.wav", 70, 100)
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 1.6 )
	else
		dmginfo:ScaleDamage( 0.4 )
	end
end

local function UpdatePlayerVariables( Player )
	Player:SetNetworkedInt("bounty", Player.bounty)
	Player:SetNetworkedInt("cash", Player.cash)
	Player:SetNetworkedInt("multiplier", Player.multiplier)
end