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
onready var animation = get_node("AnimatedSprite")
onready var wand = $Wand
onready var hitpoints = $HitPoints

var projectile_spell = preload("res://scenes/projectile_spell.tscn")

func _process(delta):	
	
	if(Input.is_action_just_pressed("action_1")):
		_spawn_projectile_spell()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	#look_at(cursor.position)
	
	wand.look_at(cursor.position)
	wand.rotation += deg2rad(135)
	
	var diff_cursor_wand = cursor.position - wand.global_position
		
	if(diff_cursor_wand.y > 0):
		wand.z_index = 1
	else:
		wand.z_index = 0
	
	
	var diff_cursor = cursor.position - position
	
	var h_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var v_move = Input.get_action_strength("move_down")   - Input.get_action_strength("move_up")
	
	var dir = Vector2(h_move, v_move).normalized() * acceleration * delta;
		
	velocity += dir
	
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed
	
	if(diff_cursor.x > 0):
		animation.flip_h = false
	else:
		animation.flip_h = true
	
	if(dir.length() > 0):
		animation.play("run")
	else:
		animation.play("idle")
		
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
		var visuals : Node2D = spells[i].get_node("Visuals")
		var sprite : Sprite = spells[i].get_node("Visuals/Sprite")
		sprite.texture = spell_resource.profile
		
		var body = spells[i].get_node("spell_body")
		body.particles_resource = spell_resource.particles
		
		# set the direction (take into account spread)
		var direction : Vector2 = -(position - cursor.position)
		var half_n_projectiles = spell_resource.number_of_projectiles / 2.0 - 0.5
		var angle = deg2rad((spell_resource.spread * i)-(half_n_projectiles * spell_resource.spread))
		visuals.rotation = deg2rad(spell_resource.spread * i) + atan2(direction.y, direction.x)
		direction = direction.rotated(angle)
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
	
func _on_HitPoints_die():	
	get_tree().reload_current_scene()

func _on_damage_area_entered(area):	
	if(area.name == "enemy_damage_area"):
		hitpoints._damage(area.get_parent().damage)
		print(str("damaged player by ", area.get_parent().damage))
