extends Node2D

export(Color) var color
export(String) var text

func _ready():	
	$Node2D/Label.text = text
	$Node2D.modulate = color
	$AnimationPlayer.play("fade-up")

func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name == "fade-up":
		queue_free()
