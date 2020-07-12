extends TextureRect

export(Resource) var spell

onready var spell_icon = $SpellIcon
onready var cursor = $SpellIcon/Cursor
onready var text   = $SpellIcon/Label

var is_next : bool = false

func _ready():
	
	spell_icon.texture = spell.profile
	cursor.texture = preload("res://spritesheet/selector.png")
	text.text = spell.name
	
func _process(delta):	
	cursor.visible = is_next
	text.visible = is_next
