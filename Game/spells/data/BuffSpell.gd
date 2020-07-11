extends Resource
class_name BuffSpell

export(String) var name = "some buff"
export(String) var description = "description"

export(float) var time_out = 2
export(float) var interval_of_effects = 0.5

export(int) var initiative = 0

export(int) var heal_ammount = 0
export(int) var damage_ammount = 0

export(int) var poison_ammount = 0
export(int) var speed_increase_ammount = 0

export(bool) var paralyze = false

export(Texture) var profile = null
export(PackedScene) var particles = null
