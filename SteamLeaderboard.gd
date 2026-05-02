extends Node

var current_handle: int = 0
var leaderboard_handles: Dictionary[StringName, int] = {
	"FeetTraveled": 0,
	"AverageSpeed": 0
	}

# Need to connect to LeaderboardScoresDownloaded passing (Rank,Name,Score)
var LeaderboardUserScore : PackedScene

func _ready()-> void:
	Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
	Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
	Steam.leaderboard_scores_downloaded.connect(_on_leaderboard_scores_downloaded)
	
	Steam.findLeaderboard( leaderboard_handles.keys()[0] )


func _on_leaderboard_find_result(new_handle: int, was_found: int) -> void:
	if was_found != 1:
		print("Leaderboard handle could not be found: %s" % was_found)
		return

	current_handle = new_handle

	var api_name: String = Steam.getLeaderboardName(new_handle)
	leaderboard_handles[api_name] = current_handle

	print("Leaderboard %s handle found: %s" % [api_name, current_handle])

func get_handles_in_loop() -> void:
	for this_leaderboard in leaderboard_handles.keys():
		Steam.findLeaderboard(this_leaderboard)
		await Steam.leaderboard_find_result
		
func _read_leaderboard_data() -> void:
	# Parameters: Range Start, Range End, Request Type
	# Steam.LEADERBOARD_DATA_REQUEST_GLOBAL fetches the top scores
	Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, current_handle)
	

func _on_leaderboard_scores_downloaded(message: String, result: Array) -> void:
	for entry in result:
		var score = entry['score']
		var rank = entry['rank']
		var steam_id = entry['steam_id']
		var username = Steam.getFriendPersonaName(steam_id)
		print("Message from Download: " + message)
		print("Rank: %d | Name: %s | Score: %d" % [rank, username, score])

		
func _on_leaderboard_score_uploaded(success: int, this_handle: int, this_score: Dictionary) -> void:
	if success == 0:
		print("Failed to upload score to leaderboard %s" % this_handle)
		return
	print("Successfully uploaded score to leaderboard %s" % this_handle)
