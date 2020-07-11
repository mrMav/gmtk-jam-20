extends KinematicBody2D

export(NodePath) var cursorPath
export(NodePath) var spellContainerPath

export(float) var acceleration
export(float) var max_speed
export(float) var drag
export(float) var mouse_sensitivity = 0.01
export(float) var controller_sensitivity = 4

export(Array, Resource) var spells : Array

var velocity : Vector2 = Vector2.ZERO
onready var cursor = get_node(cursorPath)
onready var spell_container = get_node(spellContainerPath)

var projectile_spell = preload("res://scenes/projectile_spell.tscn")

func _process(delta):	
	
	if(Input.is_action_just_pressed("action_1")):
		_spawn_projectile_spell()
	

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
	
func _spawn_projectile_spell():
	
	# from the list of spells
	# grab one and spawn with the apropriate type
	spells.shuffle()  # make actual random
	var spell_resource : ProjectileSpell = spells[0]
	
	# instanciate the number of required spells
	var spells = []
	for i in range(spell_resource.number_of_projectiles):
		
		# create the instance
		spells.push_back(projectile_spell.instance())
		
		# set the properties
		# set the image
		var sprite : Sprite = spells[i].get_node("Visuals/Sprite")
		sprite.texture = spell_resource.profile
		
		var body = spells[i].get_node("spell_body")
		
		# set the direction (take into account spread)
		var direction : Vector2 = -(position - cursor.position)
		var half_n_projectiles = spell_resource.number_of_projectiles / 2.0 - 0.5
		direction = direction.rotated(deg2rad((spell_resource.spread * i)-(half_n_projectiles * spell_resource.spread)))
		body.direction = direction.normalized()
		
		# set position to the current player position
		body.position = position
		
		# set the speed that this spell travels at
		body.acceleration = spell_resource.acceleration
		
		# set the self rotation of the spell
		body.rotation_speed = spell_resource.rotation_speed
		
		# set damage
		body.damage = spell_resource.damage
				
		body.drag = spell_resource.drag
				
		body.time_to_kill = spell_resource.time_to_kill
		
		spell_container.add_child(spells[i], true)
	
#	var s = projectile_spell.instance()
	
	
#	var spell_body = s.get_node("spell_body")
	
	# set all the projectile variables from created resource	
#	spell_body.speed = spell_resource.velocity
#	spell_body.direction = -direction.normalized()
#	spell_body.position = position
#	spell_body.damage = spell_resource.damage
#	spell_body.number_of_projectiles = spell_resource.number_of_projectiles
#	spell_body.spread = spell_resource.spread
#	spell_body.rotation_speed = spell_resource.rotation_speed
	
#	spell_container.add_child(s, true)
	
	
	
	
	
	
