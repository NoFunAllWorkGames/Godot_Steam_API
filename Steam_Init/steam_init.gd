extends Node

var app_id = 480

var achievements: Dictionary[String, bool] = {
	"ACH_TRAVEL_FAR_ACCUM": false,
	"ACH_TRAVEL_FAR_SINGLE": false,
	"ACH_WIN_100_GAMES": false
	}
var statistics: Dictionary[String, int] = {
	"highscore": 0,
	"health": 0,
	"money": 0
	}

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx( 480, true )
	print("Did Steam initialize?: %s" % initialize_response)

	if initialize_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)


	var app_installed_depots: Array = Steam.getInstalledDepots( app_id )
	var app_languages: String = Steam.getAvailableGameLanguages()
	var app_owner: int = Steam.getAppOwner()
	var build_id: int = Steam.getAppBuildId()
	var game_language: String = Steam.getCurrentGameLanguage()
	var install_dir: String = Steam.getAppInstallDir( app_id )
	var is_on_steam_deck: bool = Steam.isSteamRunningOnSteamDeck()
	var is_on_vr: bool = Steam.isSteamRunningInVR()
	var is_online: bool = Steam.loggedOn()
	var is_owned: bool = Steam.isSubscribed()
	var launch_command_line: String = Steam.getLaunchCommandLine()
	var steam_id: int = Steam.getSteamID()
	var steam_username: String = Steam.getPersonaName()
	var ui_language: String = Steam.getSteamUILanguage()
	
	$VBoxContainer/HBoxContainer/key.text = "App installed depots"
	$VBoxContainer/HBoxContainer/value.text = str(app_installed_depots)

	$VBoxContainer/HBoxContainer2/key.text = "App languages"
	$VBoxContainer/HBoxContainer2/value.text = str(app_languages)

	$VBoxContainer/HBoxContainer3/key.text = "App owner"
	$VBoxContainer/HBoxContainer3/value.text = str(app_owner)

	$VBoxContainer/HBoxContainer4/key.text = "Build id"
	$VBoxContainer/HBoxContainer4/value.text = str(build_id)

	$VBoxContainer/HBoxContainer5/key.text = "Game language"
	$VBoxContainer/HBoxContainer5/value.text = str(game_language)

	$VBoxContainer/HBoxContainer6/key.text = "Install dir"
	$VBoxContainer/HBoxContainer6/value.text = str(install_dir)

	$VBoxContainer/HBoxContainer7/key.text = "Is on steam deck"
	$VBoxContainer/HBoxContainer7/value.text = str(is_on_steam_deck)

	$VBoxContainer/HBoxContainer8/key.text = "Is on vr"
	$VBoxContainer/HBoxContainer8/value.text = str(is_on_vr)
	
	$VBoxContainer/HBoxContainer9/key.text = "Is online"
	$VBoxContainer/HBoxContainer9/value.text = str(is_online)

	$VBoxContainer/HBoxContainer10/key.text = "Is owned"
	$VBoxContainer/HBoxContainer10/value.text = str(is_owned)

	$VBoxContainer/HBoxContainer11/key.text = "Launch command line"
	$VBoxContainer/HBoxContainer11/value.text = str(launch_command_line)
	
	$VBoxContainer/HBoxContainer12/key.text = "Steam id"
	$VBoxContainer/HBoxContainer12/value.text = str(steam_id)

	$VBoxContainer/HBoxContainer13/key.text = "Steam username"
	$VBoxContainer/HBoxContainer13/value.text = str(steam_username)

	$VBoxContainer/HBoxContainer14/key.text = "UI language"
	$VBoxContainer/HBoxContainer14/value.text = str(ui_language)
	
	print("=== Start Steam Init Start ====")
	print("App installed depots: %s" % [app_installed_depots])
	print("App languages: %s" % app_languages)
	print("App owner: %s" % app_owner)
	print("Build id: %s" % build_id)
	print("Game language: %s" % game_language)
	print("Install dir: %s" % install_dir)
	print("Is on steam deck: %s" % is_on_steam_deck)
	print("Is on vr: %s" % is_on_vr)
	print("Is online: %s" % is_online)
	print("Is owned: %s" % is_owned)
	print("Launch command line: %s" % launch_command_line)
	print("Steam id: %s" % steam_id)
	print("Steam username: %s" % steam_username)
	print("UI language: %s" % ui_language)
	print("=== END Steam Init END ====")
	print("")

	print("=== START Steam Achievement Load ====")
	load_steam_achievements()
	print("=== END Steam Achievement Load ====")

# Process achievements
func load_steam_achievements() -> void:
	for this_achievement in achievements.keys():
		var steam_achievement: Dictionary = Steam.getAchievement(this_achievement)

		# Does the achievement actually exist in the Steamworks back-end?
		# It's not mentioned in the documentation but 'ret' = 'returned dictionary'
		if not steam_achievement['ret']:
			print("Steam does not have this achievement, ignoring it")
			continue

		achievements[this_achievement] = steam_achievement['achieved']

	print("Steam achievements loaded")
	for k in achievements:
		var v = achievements[k]
		print("Key: %s " % k, "Unlocked?: %s " % v)
