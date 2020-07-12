extends Node

signal die

onready var pop_up_container = get_tree().root.get_node("World/Popup_Container")
onready var popup = preload("res://scenes/TextPopup/TextPopup.tscn")

var max_points : int
var current_hitpoints : int

func _ready():
	current_hitpoints = max_points

func _damage(amount : int):
	
	current_hitpoints -= amount
	
	var p = popup.instance()
	p.color = "#ff0000"
	p.text = str(amount)
	p.position = get_parent().position
	
	p.position.x += randf() * 2
	p.position.y += randf() * 2
	
	pop_up_container.add_child(p, true)
	
	if(current_hitpoints <= 0):
		emit_signal("die")
