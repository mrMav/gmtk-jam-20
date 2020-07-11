extends Node

signal die

export(int) var max_points = 10

var current_hitpoints;

func _ready():
	current_hitpoints = max_points	

func _damage(amount : int):
	current_hitpoints -= amount
	
	if(current_hitpoints <= 0):
		emit_signal("die")
