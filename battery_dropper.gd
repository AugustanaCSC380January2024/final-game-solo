extends Node

var battery = preload("res://Scenes/battery.tscn")

func drop_batteries(round, enemy_pos):
	for num in range(0, round*10):
			if randi() % 2:
				var battery_instance = battery.instantiate()
				battery_instance.scale = Vector2(1.5,1.5)
				add_child(battery_instance)
				battery_instance.global_position = enemy_pos + Vector2(randf_range(-10,10), randf_range(-10,10))
