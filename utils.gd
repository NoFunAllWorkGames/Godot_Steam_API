class_name utils 
# No 'extends' keyword means it defaults to RefCounted/Object

static func clean_container(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

static func getFriends():
	# Declare arrays, will be used later on
	var offlineFriends : Array
	var onlineFriends : Array
	var ingameFriends : Array

# Loop iteration over friend list
	for i in range(0, Steam.getFriendCount(Steam.FRIEND_FLAG_IMMEDIATE)):
		var friendId = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var online = Steam.getFriendPersonaState(friendId)
		var gameDetails = Steam.getFriendGamePlayed(friendId)
		var friends = {
			"online" : true if online == 1 else false,
			# Have to use .get() to access dictionary under gameDetails for string print below
			# This is because some friends return <null> = not playing a game
			"gameId" : gameDetails.get("id", null),
			"name" : Steam.getFriendPersonaName(friendId)
		}

# Print online friends to output
		if friends["online"] == true:
			print('"%s" is online playing: %s' % [friends["name"], friends["gameId"]])
		else:
			pass
