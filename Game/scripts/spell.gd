extends Node

var speed
var direction
var position

onready var area = get_node("Area2D");

# Called when the node enters the scene tree for the first time.
func _ready():
	
	area.speed = speed
	area.direction = direction
	area.position = position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
