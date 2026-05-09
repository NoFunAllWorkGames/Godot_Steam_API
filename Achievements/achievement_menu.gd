extends Control

const achievementPanel: PackedScene = preload("res://Achievements/achievement_panel.tscn")

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

func _ready() -> void:
		visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		print("=== START Steam Achievement Load ====")
		load_steam_achievements()
		print("=== END Steam Achievement Load ====")


# Process achievements
	# Does the achievement actually exist in the Steamworks back-end?
	# https://partner.steamgames.com/doc/features/achievements/ach_guide
	# https://partner.steamgames.com/doc/api/ISteamUserStats#GetAchievement
	# It's not mentioned in the documentation but 'ret' = 'returned dictionary'
	# https://godotsteam.com/classes/user_stats/?h=achiev#getachievement
	# See Returns: dictionary -> Contains the following keys: -> ret
func load_steam_achievements() -> void:
	for this_achievement in achievements.keys():
		var steam_achievement: Dictionary = Steam.getAchievement(this_achievement)
		

		if not steam_achievement['ret']:
			print("Steam does not have this achievement, ignoring it")
			continue

		achievements[this_achievement] = steam_achievement['achieved']

	for key in achievements:
		var achievement_status = achievements[key]
		var grid = achievementPanel.instantiate()
		$Panel/MarginContainer/ScrollContainer/GridContainer.add_child(grid)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Name").text = str("Key: %s" % key)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Status").text = str("Unlocked?: %s" % achievement_status)
		var icon = grid.get_node("MarginContainer/HBoxContainer/TextureRect")
		load_achievement_icon(icon, key)
		
		print("Key: %s " % key, "Unlocked?: %s " % achievement_status)

func load_achievement_icon(icon: TextureRect, k) -> void:
	var icon_handle: int = Steam.getAchievementIcon(k)

	var icon_size: Dictionary = Steam.getImageSize(icon_handle)
	var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
	if not icon_buffer.has("buffer"):
		return

	var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])

	var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
	icon.texture = icon_texture
