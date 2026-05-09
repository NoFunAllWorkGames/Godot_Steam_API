extends Control

const achievementPanel: PackedScene = preload("res://Achievements/achievement_panel.tscn")

var existing_achievements: Array = []

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
		existing_achievements = get_all_achievements()
		load_steam_achievements()
		print("=== END Steam Achievement Load ====")


func get_all_achievements() -> Array:
	var achievement_list: Array = []

	# 1. Get the total number of achievements defined in Steamworks
	var total_achievements: int = Steam.getNumAchievements()

	# 2. Iterate through each index to get the API Name
	for i in range(total_achievements):
		var achievement_name: String = Steam.getAchievementName(i)

		# 3. Retrieve specific data for that achievement
		var achievement_data: Dictionary = Steam.getAchievement(achievement_name)

		# 'ret' indicates if the call was successful
		if achievement_data['ret']:
			achievement_list.append({
				"achievement_name": achievement_name,
				"is_unlocked": achievement_data['achieved']
			})

	return achievement_list

# Process achievements
	# Does the achievement actually exist in the Steamworks back-end?
	# https://partner.steamgames.com/doc/features/achievements/ach_guide
	# https://partner.steamgames.com/doc/api/ISteamUserStats#GetAchievement
	# It's not mentioned in the documentation but 'ret' = 'returned dictionary'
	# https://godotsteam.com/classes/user_stats/?h=achiev#getachievement
	# See Returns: dictionary -> Contains the following keys: -> ret
func load_steam_achievements() -> void:
	for this_achievement in existing_achievements:
		var achievement_name = this_achievement["achievement_name"]
		var is_unlocked = this_achievement["is_unlocked"]
		var grid = achievementPanel.instantiate()
		$Panel/MarginContainer/ScrollContainer/GridContainer.add_child(grid)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Name").text = str("Key: %s" % achievement_name)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Status").text = str("Unlocked?: %s" % is_unlocked)
		var iconRect = grid.get_node("MarginContainer/HBoxContainer/TextureRect")
		load_achievement_icon(iconRect, achievement_name)

		print("Key: %s " % achievement_name, "Unlocked?: %s " % is_unlocked)

func load_achievement_icon(iconRect: TextureRect, achievement_name: String) -> void:
	var icon_handle: int = Steam.getAchievementIcon(achievement_name)

	var icon_size: Dictionary = Steam.getImageSize(icon_handle)
	var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
	if not icon_buffer.has("buffer"):
		return

	var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])

	var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
	iconRect.texture = icon_texture
