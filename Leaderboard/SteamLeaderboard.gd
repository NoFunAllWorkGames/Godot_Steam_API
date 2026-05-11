extends Control

var current_handle: int = 0
var container: VBoxContainer
var leaderboards: Array = [
	"FeetTraveled",
	"MaxFeetTraveled",
	"AverageSpeed",
	"NumWins",
	"NumGames",
	"NumLosses"
]
@onready var option_button: OptionButton = $Panel/MarginContainer/ScrollContainer/VBoxContainer/Controls/OptionButton


# Need to connect to LeaderboardScoresDownloaded passing (Rank,Name,Score)
const LeaderboardUserScore: PackedScene = preload("res://Leaderboard/leaderboard_user_score.tscn")

func _ready()-> void:
	container = $Panel/MarginContainer/ScrollContainer/VBoxContainer as VBoxContainer
	# Connect the internal visibility_changed signal to a local function
	visibility_changed.connect(_on_visibility_changed)
	populate_option_button()
	option_button.item_selected.connect(_on_option_button_entry_selected)

func _on_option_button_entry_selected(index:int) -> void:
	var selection = option_button.get_item_text(index)
	clean_container()
	get_single_handle(selection)
	
func populate_option_button() -> void:
	for leaderboard in leaderboards:
		option_button.add_item((leaderboard))
	
func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		print("=== Start Steam Leaderboard Start ===")
		clean_container()
		get_single_handle("FeetTraveled")
		print("=== END Steam Leaderboard Load ====")

func get_single_handle(handle_name: String) -> void:
	print("Finding leaderboard: %s" % handle_name)
	
	Steam.findLeaderboard(handle_name)
	var result = await Steam.leaderboard_find_result
	var handle_id = result[0]
	var success = result[1]
	
	# This line does an upload of a score
	# It is here because it needs the handle and this was the easiest way to get it.
	# upload_leaderboard_score(2,false,[],handle_id)
	process_found_leaderboard(handle_id, success, handle_name)

func process_found_leaderboard(handle_id: int, success: int, handle_name: String):
	if success == 1:
		# Request the actual leaderboard content
		Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, handle_id)
		
		# Process the actual leaderboard content
		var result = await Steam.leaderboard_scores_downloaded
		var res_status = result[0]
		var res_handle = result[1]
		var res_entries = result[2]
		
		process_downloaded_leaderboard_scores(res_status, res_handle, res_entries)
	else:
		print("Failed to find leaderboard: ", handle_name)


func process_downloaded_leaderboard_scores(_res_status: String, _res_handle: int, res_entries: Array) -> void:
	#print("Downloaded entries res_status: ", res_status)
	#print("Downloaded entries res_handle: ", res_handle)
	#print("Downloaded entries res_entries: ", res_entries)
	for entry in res_entries:
		var score = entry['score']
		var rank = entry['global_rank']
		var steam_id = entry['steam_id']
		var username = Steam.getFriendPersonaName(steam_id)
		
		# Create elements for the UI
		var row = LeaderboardUserScore.instantiate()
		$Panel/MarginContainer/ScrollContainer/VBoxContainer.add_child(row)
		row.get_node("HBoxContainer/Rank").text = str(rank)
		row.get_node("HBoxContainer/Name").text = str(username)
		row.get_node("HBoxContainer/Score").text = str(score)
		
		# Debug output
		print("Rank: %d | Name: %s | Score: %d" % [rank, username, score])
		
func upload_leaderboard_score(score: int, keep_best: bool, details: Array, this_leaderboard: int) -> void:
	Steam.uploadLeaderboardScore(score, keep_best, details, this_leaderboard)
	var result = await Steam.leaderboard_score_uploaded
	var success = result[0]
	var res_handle = result[1]
	var res_score: Dictionary = result[2]
	
	print("Uploaded score success: ", success)
	print("Uploaded score res_handle: ", res_handle)
	print("Uploaded score res_score (raw): ", res_score)
	if res_score is Dictionary:
		print("  score (attempted): ", res_score.score)
		print("  score_changed: ", res_score.score_changed)
		print("  global_rank_new: ", res_score.global_rank_new)
		print("  global_rank_prev: ", res_score.global_rank_prev)

func clean_container() -> void:
	# Skip the first child because it is the header
	var i = 0
	for child in container.get_children():
		if i == 0:
			i+=1
			continue
		container.remove_child(child)
		child.queue_free()
		i+=1