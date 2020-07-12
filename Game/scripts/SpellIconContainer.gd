extends VBoxContainer

export(Array, Resource) var spell_list : Array

export(PackedScene) var profile_scene

func _ready():
	
	for i in range(spell_list.size()):
		var profile = profile_scene.instance()
		profile.spell = spell_list[i]
		add_child(profile)
				
