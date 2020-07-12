extends Area2D

var acceleration
var direction : Vector2 = Vector2.ZERO
var damage
var rotation_speed
var drag
var time_to_kill

var particles_resource : String
var particles : Particles2D = null

var velocity : Vector2 = Vector2.ZERO

var spell_killed = false

onready var visuals = get_node("../Visuals")
onready var spell_rem_timer = get_node("../spell_remove_timer")
onready var particle_rem_timer = get_node("../particle_remove_timer")
onready var collision_poligon = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	particles = load(particles_resource).instance()
	visuals.add_child(particles, true)
			
	velocity = direction * acceleration
	
	if(time_to_kill > 0):
		spell_rem_timer.start(time_to_kill)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	#if(not get_node("CollisionShape2D").disabled):
	position += velocity	
	velocity *= drag
	
	# manually set the visuals position
	# because it is not a child
	visuals.position = position
	# rotate
	visuals.rotation += rotation_speed * delta
	
	# check for death
	if(time_to_kill > 0):
		if(spell_rem_timer.time_left == 0):			
			kill_spell()
	
	# check for particle death
	if(spell_killed):
		if(particle_rem_timer.time_left == 0):
			kill_particles()
	

func kill_spell():
	if(not spell_killed):
		collision_poligon.queue_free()
		visuals.get_node("Sprite").queue_free()		
		particles.get_node("./").emitting = false
		particle_rem_timer.start(particles.lifetime)
		spell_killed = true
		#print("killed spell")

func kill_particles():
	get_node("../").queue_free()
	#print("killed spell master node")
	


func _on_Area2D_body_entered(body):	
	if(body.name != "Player"):
		kill_spell()	

func _on_spell_body_area_entered(area):
	if(area.name == "enemy_damage_area"):
		area.get_parent().get_node("./HitPoints")._damage(damage)
		kill_spell()
