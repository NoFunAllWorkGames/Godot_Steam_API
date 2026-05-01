extends Node

var app_id = 480

func _ready() -> void:
	initialize_steam()


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

	print("App installed depots: %s" % app_installed_depots)
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
