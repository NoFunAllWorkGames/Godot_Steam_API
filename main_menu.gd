extends Control

#TODO: Plug in script to variables in steam_code.gd
@onready var Label1 = $TabContainer/DebugMenu/GridContainer/Label

func _on_steam_init_steam_user_updated(res) -> void:
	$TabContainer/DebugMenu/GridContainer/Label.text = res
