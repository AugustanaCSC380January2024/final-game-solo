extends StaticBody2D

@export var max_health = 1000
var current_health = 0



func _ready():
	current_health = 0
func take_damage(damage):
	current_health += damage
	print(str(current_health) + "/" + str(max_health))




func _on_start_round_area_body_entered(body):
	if body.is_in_group("player"):
		print("called")
