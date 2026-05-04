extends Control

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
