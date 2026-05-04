extends Control

@onready var steam_init: Node = $"TabContainer/Steam Init"

func _ready() -> void:
	# This has to be always done or else steam won't work
	# It could have been an autoload too, which I try to avoid
	steam_init.initialize_steam()
