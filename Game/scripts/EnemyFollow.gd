extends KinematicBody2D

var dead = false

export(int) var hitpoints = 100
export(int) var damage = 2
export(NodePath) var player_target = null
onready var animation = get_node("AnimatedSprite")

var target

const speed = 200
const detect_dist = 16*15;
const drag = 0.98

var velocity : Vector2 = Vector2.ZERO

func _ready():
	target = get_node(player_target)
	$HitPoints.current_hitpoints = hitpoints

func _physics_process(delta):
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target.position, [self])
	
	if(result):		
		if(result.collider.name == target.name):
			animation.play("Walk")
			var dist = (target.position - position)			
			if( dist.length() <= detect_dist):		
				velocity += dist.normalized() * speed * delta	
		else:
			animation.play("Idle")
			
	velocity = move_and_slide(velocity)			
	velocity *= drag
	
	if(velocity.x > 0):
		animation.flip_h = true
	else:
		animation.flip_h = false


func _on_HitPoints_die():
	if(not dead):
		_die()

func _die():
	print(str("enemy ", name, " died"))	
	dead = true
	queue_free()
