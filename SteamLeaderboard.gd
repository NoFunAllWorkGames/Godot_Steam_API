extends Node

var current_handle: int = 0

var leaderboards: Array = [
	"FeetTraveled",
	"AverageSpeed",
	"NumWins"
]

# Need to connect to LeaderboardScoresDownloaded passing (Rank,Name,Score)
var LeaderboardUserScore : PackedScene

func _ready()-> void:
	print("=== Start Steam Leaderboard Start ===")
	get_single_handle("FeetTraveled")
	
# Optional starting point to iterate through all leaderboards
func get_handles_in_loop() -> void:
	for handle_name in leaderboards:
		get_single_handle(handle_name)
	
func get_single_handle(handle_name: String) -> void:
	print("Finding leaderboard: %s" % handle_name)
	
	Steam.findLeaderboard(handle_name)
	var result = await Steam.leaderboard_find_result
	var handle_id = result[0]
	var success = result[1]
	
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
		
		process_downloaded_leaderboard_scores(res_status,res_handle,res_entries)
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
		print("Rank: %d | Name: %s | Score: %d" % [rank, username, score])
