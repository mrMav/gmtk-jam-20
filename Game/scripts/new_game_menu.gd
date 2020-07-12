extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_game_pressed():	
	get_tree().change_scene("res://scenes/main.tscn")


func _on_help_pressed():	
	get_tree().change_scene("res://scenes/help.tscn")


func _on_quit_game_pressed():
	get_tree().quit()
