extends Area2D

var speed
var direction

onready var visuals = get_node("../Visuals")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	var velocity = direction * speed
	
	position += velocity * delta
	
	visuals.position = position



func _on_Area2D_body_entered(body):
	
	if(body.name != "Player"):
		queue_free()
		visuals.get_node("Sprite").queue_free()
		visuals.get_node("Particles2D").emitting = false
	
	
	pass # Replace with function body.
