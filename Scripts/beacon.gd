extends StaticBody2D

@export var max_health = 1000
var current_health = 0

signal beacon_take_damage

func _ready():
	current_health = 0
func take_damage(damage):
	current_health += damage
	beacon_take_damage.emit()
	print(str(current_health) + "/" + str(max_health))



