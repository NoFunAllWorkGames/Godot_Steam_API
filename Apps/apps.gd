extends MarginContainer

var container: VBoxContainer
var panel: HBoxContainer

var spacewarFiles :Array = [
	"spacewar.exe",
	"steam_api64.dll",
	"steam_appid.txt",
	"sourceinit.dat"
]

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
func _on_visibility_changed():
	if is_visible_in_tree():
		print("=== Start Steam Apps Start ===")
		container = $ScrollContainer/VBoxContainer
		panel = $ScrollContainer/VBoxContainer/HBoxContainer
		getAppInfos()
		print("=== END Steam Apps Load ====")

func getAppInfos():
	var app_build_id: int = Steam.getAppBuildId()
	var app_install_dir: String = Steam.getAppInstallDir(Steam.getAppID())
	var app_owner: int = Steam.getAppOwner()
	var available_languages: String = Steam.getAvailableGameLanguages()
	var beta_info: Dictionary = Steam.getBetaInfo()
	var current_beta_name: String = Steam.getCurrentBetaName()
	var current_game_language: String = Steam.getCurrentGameLanguage()
	var dlc_count: int = Steam.getDLCCount()
	var dlc_data: Array = Steam.getDLCData() 
	var dlc_data_by_index: Dictionary = Steam.getDLCDataByIndex(0)
	var dlc_download_progress: Dictionary = Steam.getDLCDownloadProgress(0)
	var earliest_purchase_time: int = Steam.getEarliestPurchaseUnixTime(Steam.getAppID())
	# seems buggy
	#Steam.getFileDetails(spacewarFiles[0])
	#var file_details = await Steam.file_details_result
	var installed_depots: Array = Steam.getInstalledDepots(Steam.getAppID())
	var launch_command_line: String = Steam.getLaunchCommandLine()
	var launch_query_param: String = Steam.getLaunchQueryParam("key")
	var num_betas: Dictionary = Steam.getNumBetas()
	var app_installed: bool = Steam.isAppInstalled(Steam.getAppID())
	# Error at (40, 28): Static function "isCyberCafe()" not found in base "GDScriptNativeClass".
	# var cyber_cafe: bool = Steam.isCyberCafe()
	var dlc_installed: bool = Steam.isDLCInstalled(0)
	var low_violence: bool = Steam.isLowViolence()
	var subscribed: bool = Steam.isSubscribed()
	var subscribed_app: bool = Steam.isSubscribedApp(Steam.getAppID())
	var subscribed_family_sharing: bool = Steam.isSubscribedFromFamilySharing()
	var subscribed_free_weekend: bool = Steam.isSubscribedFromFreeWeekend()
	var timed_trial: Dictionary = Steam.isTimedTrial()
	var vac_banned: bool = Steam.isVACBanned()
	
	createNewPanelEntry("app_build_id", str(app_build_id))
	createNewPanelEntry("app_install_dir", str(app_install_dir))
	createNewPanelEntry("app_owner", str(app_owner))
	createNewPanelEntry("available_languages", str(available_languages))
	createNewPanelEntry("beta_info", str(beta_info))
	createNewPanelEntry("current_beta_name", str(current_beta_name))
	createNewPanelEntry("current_game_language", str(current_game_language))
	createNewPanelEntry("dlc_count", str(dlc_count))
	createNewPanelEntry("dlc_data", str(dlc_data))
	createNewPanelEntry("dlc_data_by_index", str(dlc_data_by_index))
	createNewPanelEntry("dlc_download_progress", str(dlc_download_progress))
	createNewPanelEntry("earliest_purchase_time", str(earliest_purchase_time))
	#createNewPanelEntry("file_details", str(file_details))
	createNewPanelEntry("installed_depots", str(installed_depots))
	createNewPanelEntry("launch_command_line", str(launch_command_line))
	createNewPanelEntry("launch_query_param", str(launch_query_param))
	createNewPanelEntry("num_betas", str(num_betas))
	createNewPanelEntry("app_installed", str(app_installed))
	createNewPanelEntry("dlc_installed", str(dlc_installed))
	createNewPanelEntry("low_violence", str(low_violence))
	createNewPanelEntry("subscribed", str(subscribed))
	createNewPanelEntry("subscribed_app", str(subscribed_app))
	createNewPanelEntry("subscribed_family_sharing", str(subscribed_family_sharing))
	createNewPanelEntry("subscribed_free_weekend", str(subscribed_free_weekend))
	createNewPanelEntry("timed_trial", str(timed_trial))
	createNewPanelEntry("vac_banned", str(vac_banned))

# Create a new panel and assigns the values
func createNewPanelEntry(entry_name:String, entry_value:String) -> void:
	var entry_panel = panel.duplicate() as HBoxContainer
	var name_label: Label = entry_panel.get_node("Name")
	name_label.text = entry_name
	name_label.name = entry_name
	var value_label: Label = entry_panel.get_node("Key")
	value_label.text = entry_value
	value_label.name = entry_name + "_value"
	container.add_child(entry_panel)
