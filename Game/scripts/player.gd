extends KinematicBody2D

export(NodePath) var cursorPath
export(NodePath) var spellContainerPath

export(float) var health = 100
export(float) var acceleration
export(float) var max_speed
export(float) var drag
export(float) var mouse_sensitivity = 0.01
export(float) var controller_sensitivity = 4

export(Array, Resource) var spells : Array
export(Array, Resource) var buffs  : Array

var active_buffs : Array

var velocity : Vector2 = Vector2.ZERO
onready var cursor = get_node(cursorPath)
onready var spell_container = get_node(spellContainerPath)
onready var animation = get_node("AnimatedSprite")
onready var wand = $Wand
onready var hitpoints = $HitPoints

var projectile_spell = preload("res://scenes/projectile_spell.tscn")

func _ready():
	hitpoints.current_hitpoints = health

func _process(delta):	
	
	if(Input.is_action_just_pressed("action_1")):
		_spawn_projectile_spell()
	
	if(Input.is_action_just_pressed("action_2")):
		_apply_buff()
	
	# remove outdated buffs
	for i in range(active_buffs.size() - 1, -1, -1):
		var now = OS.get_unix_time()
		var buff = active_buffs[i]
		if(buff.applied_at + buff.spell_time_out < now):
			if(buff.particles_instance):
				buff.particles_instance.queue_free()
			active_buffs.remove(i)
			print(str("removed buff ", buff.name))
	
	# update buffs effects
	for i in range(active_buffs.size()):
		var now = OS.get_unix_time()
		var buff = active_buffs[i]
		if(buff.next_effect < now):
			# apply
			if(buff.health_effect > 0):
				hitpoints._heal(buff.health_effect)
			if(buff.damage_effect > 0):
				hitpoints._damage(buff.damage_effect, "#ff0000")
			if(buff.poison_effect > 0):
				hitpoints._damage(buff.poison_effect, "#0000ff")
				
			buff.next_effect = now + buff.interval_of_effects


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
	
	
	var acc = acceleration	
	for j in range(active_buffs.size()):
		var buff = active_buffs[j]
		if(buff.speed_debuff_ammount != 0):
			acc *= buff.speed_debuff_ammount
		if(buff.paralyze):
			acc *= Vector2.ZERO
	var dir = Vector2(h_move, v_move).normalized() * acc * delta;
		
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
	
	if spell_resource.name == "Ocean Drop":
		print("OOF")
		
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
		
		# set damage, but take into account debuffs
		var total_damage = spell_resource.damage
		for j in range(active_buffs.size()):
			var buff = active_buffs[j]
			if(buff.damage_debuff_ammount != 0):
				total_damage *= buff.damage_debuff_ammount					
		body.damage = total_damage
				
		body.drag = spell_resource.drag
				
		body.time_to_kill = spell_resource.time_to_kill
		
		spell_container.add_child(spells[i], true)

func _apply_buff():
	
	buffs.shuffle()
	var buff_res = buffs[0]
	var buff : Buff = Buff.new()
	
	buff.name = buff_res.name
	buff.description = buff_res.description
	
	buff.spell_time_out = buff_res.spell_time_out
	buff.interval_of_effects = buff_res.interval_of_effects

	buff.initiative = buff_res.initiative

	buff.health_effect = buff_res.health_effect
	buff.damage_effect = buff_res.damage_effect
	buff.poison_effect = buff_res.poison_effect

	buff.speed_debuff_ammount = buff_res.speed_debuff_ammount
	buff.damage_debuff_ammount = buff_res.damage_debuff_ammount 

	buff.paralyze = buff_res.paralyze

	buff.profile = buff_res.profile
	buff.particles = buff_res.particles	
	
	buff.applied_at = OS.get_unix_time()
	buff.next_effect = 0
	
	print(buff.particles)
	
	if(buff.particles):		
		buff.particles_instance = buff_res.particles.instance()
		buff.particles_instance.position = Vector2.ZERO
		add_child(buff.particles_instance, true)
		buff.particles_instance.emitting = true
	
	
	var notifications_offset = 0
	var offset_ammount = -12
	if(buff.paralyze):
		hitpoints._notify("Paralyzed!", Color.yellow)
	
	if(buff.speed_debuff_ammount > 0 and buff.speed_debuff_ammount < 1):
		hitpoints._notify(str(buff.speed_debuff_ammount * 100 - 100, "% slower!"), Color.blueviolet, notifications_offset)
		notifications_offset += offset_ammount
	if(buff.speed_debuff_ammount > 1):
		hitpoints._notify(str(buff.speed_debuff_ammount * 100 - 100, "% faster!"), Color.blue, notifications_offset)
		notifications_offset += offset_ammount
	
	if(buff.damage_debuff_ammount > 0 and buff.damage_debuff_ammount < 1):
		hitpoints._notify(str(buff.damage_debuff_ammount * 100 - 100, "% less damage!"), Color.blueviolet, notifications_offset)
		notifications_offset += offset_ammount
	if(buff.damage_debuff_ammount > 1):
		hitpoints._notify(str(buff.damage_debuff_ammount * 100 - 100, "% more damage!"), Color.orange, notifications_offset)
		notifications_offset += offset_ammount
		
	
	active_buffs.push_back(buff)
	
	print(str("added buff ", buff.name))
	
	
#export(String) var name = "some buff"
#export(String) var description = "description"
#
#export(float) var spell_time_out = 2
#export(float) var interval_of_effects = 0.5
#
#export(int) var initiative = 0
#
#export(int) var health_effect = 0
#export(int) var damage_effect = 0
#export(int) var poison_effect = 0
#
#export(float) var speed_debuff_ammount = 0
#export(float) var damage_debuff_ammount = 0
#
#export(bool) var paralyze = false
#
#export(Texture) var profile = null
#export(PackedScene) var particles = null
	


func _on_HitPoints_die():	
	get_tree().reload_current_scene()

func _on_damage_area_entered(area):	
	if(area.name == "enemy_damage_area"):
		hitpoints._damage(area.get_parent().damage, "#ff0000")
		print(str("damaged player by ", area.get_parent().damage))

class Buff:
	
	var name = "some buff"
	var description = "description"

	var spell_time_out = 2
	var interval_of_effects = 0.5

	var initiative = 0

	var health_effect = 0
	var damage_effect = 0
	var poison_effect = 0

	var speed_debuff_ammount = 0
	var damage_debuff_ammount = 0

	var paralyze = false

	var profile = null
	var particles = null
		
	var applied_at = 0
	var next_effect = 0

	var particles_instance = null
