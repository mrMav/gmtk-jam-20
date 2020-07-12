tool
extends Label


export(bool) var center_text setget center

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	center()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func center(_value = null):
	var size = get_size()
	margin_left = -size.x / 2
	margin_right = size.x / 2
	margin_top = -size.y / 2
	margin_bottom = size.y / 2
	
