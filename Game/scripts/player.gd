extends KinematicBody2D

export(float) var acceleration
export(float) var max_speed
export(float) var drag

var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var h_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var v_move = Input.get_action_strength("move_down")   - Input.get_action_strength("move_up")
	
	var dir = Vector2(h_move, v_move) * acceleration * delta;
		
	velocity += dir
	
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	
	velocity = move_and_slide(velocity)
	
	
	velocity *= drag
	
