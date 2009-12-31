GM.Name 	= "Bounty"
GM.Author 	= "Ljdp"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "Each kill gains you cash and bounty. Kill the person with the highest bounty."
 
GM.Data = {}
 
DeriveGamemode( "fretta" )
IncludePlayerClasses()					// Automatically includes files in "gamemode/player_class"
 
GM.TeamBased = false					// Team based game or a Free For All game?
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.GameLength = 15
GM.RoundLimit = 20					// Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					// Delay between end of game, and vote. if you want to display any extra screens before the vote pops up
 
GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerTeamDamage = false
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats

GM.TakeFragOnSuicide = false			// -1 frag on suicide
 
GM.MaximumDeathLength = 8			// Player will respawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 7			// Player has to be dead for at least this long
GM.RealisticFallDamage = false
 
GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 60 * 5				// Round length, in seconds
GM.RoundPreStartTime = 1			// Preperation time before a round starts
GM.RoundPostLength = 5				// Seconds to show the 'x team won!' screen at the end of a round
 
GM.EnableFreezeCam = true			// TF2 Style Freezecam
GM.DeathLingerTime = 1				// The time between you dying and it going into spectator mode, 0 disables
 
GM.SelectModel = true               // Can players use the playermodel picker in the F1 menu?
GM.SelectColor = false				// Can players modify the colour of their name? (ie.. no teams)
 
GM.PlayerRingSize = 48              // How big are the colored rings under the player's feet (if they are enabled) ?
GM.HudSkin = "SimpleSkin"
 
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }
GM.ValidSpectatorEntities = { "player" }	// Entities we can spectate

function GM:CreateTeams()
	team.SetUp( TEAM_UNASSIGNED, "Default Team", Color( 90, 90, 255, 255 ), true )
	team.SetSpawnPoint( TEAM_UNASSIGNED,{"info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch"} )
	team.SetClass( TEAM_UNASSIGNED, { "PistolMan", "Bang", "Whipper", "LongShot" } )
end
 