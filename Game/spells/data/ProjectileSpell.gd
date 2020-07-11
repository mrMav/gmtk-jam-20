extends Resource
class_name ProjectileSpell

export(String) var name = "Projectile Spell"
export(String) var description = "Your basic spell"
export(int) var initiative = 0
export(int) var damage     = 0
export(int) var acceleration = 0
export(float) var drag     = 0
export(float) var time_to_kill = 0
export(int) var number_of_projectiles = 1
export(float) var spread = 0
export(float) var rotation_speed = 2
export(int) var trailing_number = 0
export(float) var trailing_spacing = 0 
export(Texture) var profile  = null
export(String) var particles = null
