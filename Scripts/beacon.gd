extends StaticBody2D

@export var health = 1000

func _ready():
	health = 0
func take_damage(damage):
	health += damage
