extends KinematicBody2D

export(NodePath) var player_target = null

var target

const speed = 400
const detect_dist = 16*15;
const drag = 0.98

var velocity = Vector2.ZERO

func _ready():
	target = get_node(player_target)
	

func _physics_process(delta):
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target.position, [self])
	
	if(result):		
		if(result.collider.name == target.name):
			var dist = (target.position - position)			
			if( dist.length() <= detect_dist):		
				velocity += dist.normalized() * speed * delta	
			
	velocity = move_and_slide(velocity)			
	velocity *= drag
