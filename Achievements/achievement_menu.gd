extends Control

const achievementPanel: PackedScene = preload("res://Achievements/achievement_panel.tscn")
var grid_container: GridContainer
var existing_achievements: Array = []

signal setAchievementSignal
signal clearAchievementSignal

var statistics: Dictionary[String, int] = {
	"highscore": 0,
	"health": 0,
	"money": 0
	}

func _ready() -> void:
	grid_container = $Panel/MarginContainer/ScrollContainer/GridContainer as GridContainer
	visibility_changed.connect(_on_visibility_changed)
	Steam.user_achievement_icon_fetched.connect(_on_user_achievement_icon_fetched)

func _on_visibility_changed() -> void:
	print("=== START Steam Achievement Load ====")
	clean_grid_container()
	existing_achievements = get_all_achievements()
	load_steam_achievements()
	print("=== END Steam Achievement Load ====")

func clean_grid_container() -> void:
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

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
		var grid = create_achievement_panel_node(achievement_name)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Name").text = str("Key: %s" % achievement_name)
		grid.get_node("MarginContainer/HBoxContainer/VBoxContainer/Status").text = str("Unlocked?: %s" % is_unlocked)
		var iconRect = grid.get_node("MarginContainer/HBoxContainer/TextureRect")
		iconRect.name = achievement_name
		load_achievement_icon_from_name(iconRect, achievement_name)

		print("Key: %s " % achievement_name, "Unlocked?: %s " % is_unlocked)
		
func create_achievement_panel_node(achievement_name :String) -> Panel:
	# Actually create the achievement panel node
	var grid = achievementPanel.instantiate()
	grid_container.add_child(grid)
	grid.name = achievement_name
	# Just shortcut for the Set and Clear buttons
	var setButton = grid.get_node("MarginContainer/HBoxContainer/ButtonVBoxContainer/Set")
	var clearButton = grid.get_node("MarginContainer/HBoxContainer/ButtonVBoxContainer/Clear")
	# Connect the signals to those buttons
	setButton.pressed.connect(_on_set_Achievement.bind(achievement_name))
	clearButton.pressed.connect(_on_clear_Achievement.bind(achievement_name))
	return grid

func load_achievement_icon_from_name(iconRect: TextureRect, achievement_name: String) -> void:
	var icon_handle: int = Steam.getAchievementIcon(achievement_name)
	load_achievement_icon_from_handle(iconRect, icon_handle)

func load_achievement_icon_from_handle(iconRect: TextureRect, icon_handle: int) -> void:
	var icon_size: Dictionary = Steam.getImageSize(icon_handle)
	var icon_buffer: Dictionary = Steam.getImageRGBA(icon_handle)
	if not icon_buffer.has("buffer"):
		return

	var icon_image: Image = Image.create_from_data(icon_size.width, icon_size.height, false, Image.FORMAT_RGBA8, icon_buffer["buffer"])

	var icon_texture: ImageTexture = ImageTexture.create_from_image(icon_image)
	iconRect.texture = icon_texture

func _on_user_achievement_icon_fetched(game_id: int, achievement_name: String, achieved:bool, icon_handle: int) -> void:
	print("Icon " + achievement_name + " late to the party! Adding it to the UI")
	var iconRect = find_child(achievement_name, true, false) as TextureRect
	load_achievement_icon_from_handle(iconRect, icon_handle)
	
func _on_set_Achievement(name: String):
	Steam.setAchievement(name)
	_on_refresh_pressed()
	
func _on_clear_Achievement(name: String):
	Steam.clearAchievement(name)
	_on_refresh_pressed()

func _on_refresh_pressed() -> void:
	# Remove old entries
	clean_grid_container()
	
	# Create timer to wait (not actually required but using to showcase a fetch from server)
	await get_tree().create_timer(1.0).timeout
	
	# Load achievements
	load_steam_achievements()
