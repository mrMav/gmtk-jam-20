extends Node

signal die

onready var pop_up_container = get_tree().root.get_node("World/Popup_Container")
onready var popup = preload("res://scenes/TextPopup/TextPopup.tscn")

var rng = RandomNumberGenerator.new()

var max_points : int
var current_hitpoints : int

func _ready():
	current_hitpoints = max_points

func _damage(amount : int, color : Color):
	
	current_hitpoints -= amount
	
	var p = popup.instance()
	p.color = color
	p.text = str("-", amount)
	p.position = get_parent().position
	
	p.position.x += rng.randf_range(-5, 5)
	p.position.y += rng.randf_range(-5, 5)
	
	pop_up_container.add_child(p, true)
	
	if(current_hitpoints <= 0):
		emit_signal("die")

func _heal(amount : int):
	
	current_hitpoints += amount
	
	var p = popup.instance()
	p.color = "#00ff00"
	p.text = str("+", amount)
	p.position = get_parent().position
	
	p.position.x += rng.randf_range(-5, 5)
	p.position.y += rng.randf_range(-5, 5)
	
	pop_up_container.add_child(p, true)
	
func _notify(text : String, color : Color, offset : int = 0):
		
	var p = popup.instance()
	p.color = color
	p.text = text
	p.position = get_parent().position
	
	p.position.y += offset
	
	pop_up_container.add_child(p, true)
		
