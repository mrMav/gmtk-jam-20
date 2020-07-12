extends Resource
class_name BuffSpell

export(String) var name = "some buff"
export(String) var description = "description"

export(float) var spell_time_out = 2
export(float) var interval_of_effects = 0.5

export(int) var initiative = 0

export(int) var health_effect = 0
export(int) var damage_effect = 0
export(int) var poison_effect = 0

export(float) var speed_debuff_ammount = 0
export(float) var damage_debuff_ammount = 0

export(bool) var paralyze = false

export(Texture) var profile = null
export(PackedScene) var particles = null
