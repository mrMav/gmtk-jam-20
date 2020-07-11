extends KinematicBody2D

export(NodePath) var cursorPath
export(NodePath) var spellContainerPath

export(float) var acceleration
export(float) var max_speed
export(float) var drag
export(float) var mouse_sensitivity = 0.01
export(float) var controller_sensitivity = 4

var velocity : Vector2 = Vector2.ZERO
onready var cursor = get_node(cursorPath)
onready var spell_container = get_node(spellContainerPath)

var spell = preload("res://scenes/spell.tscn")

func _process(delta):	
	
	if(Input.is_action_pressed("action_1")):
		#fire spell
		
		# give spell a speed and direction
		var direction : Vector2 = position - cursor.position
		var speed = 800
		
		var s = spell.instance()
		s.speed = speed
		s.direction = -direction.normalized()
		s.position = position
		
		spell_container.add_child(s, true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	look_at(cursor.position)
	
	var h_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var v_move = Input.get_action_strength("move_down")   - Input.get_action_strength("move_up")
	
	var dir = Vector2(h_move, v_move) * acceleration * delta;
		
	velocity += dir
	
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	
	velocity = move_and_slide(velocity)
		
	velocity *= drag
	
