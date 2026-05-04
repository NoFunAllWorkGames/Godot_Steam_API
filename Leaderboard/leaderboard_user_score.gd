extends Panel

func SetUpLeaderboardScore(rank,name,score):
	$HBoxContainer/Rank.text = str(rank)
	$HBoxContainer/Name.text = name
	$HBoxContainer/Score.text = score
