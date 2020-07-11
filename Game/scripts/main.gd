extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		
func _process(delta):
	
	# exit game
	if(Input.get_action_strength("ui_cancel")):
		get_tree().quit()
	
