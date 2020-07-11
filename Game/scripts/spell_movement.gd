extends Area2D

var speed
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	var velocity = direction * speed
	
	position += velocity * delta
	



func _on_Area2D_body_entered(body):
	
	if(body.name != "Player"):
		queue_free()
	
	pass # Replace with function body.
