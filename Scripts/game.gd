extends Node2D

@onready var level = $Level/SpawnAreas
@onready var player = get_node("Player")
@onready var beacon = get_node("Beacon")

var spawn_areas = []

func _ready():
	get_spawn_areas()
	
func get_spawn_areas():
	for spawn_area in level.get_children():
		spawn_areas.append(spawn_area)

func clear_spawn_area():
	spawn_areas.clear()
	
func spawn_enemies(amount, player, beacon):
	for enemy_num in amount:
		var random_spawn = spawn_areas.pick_random()
		random_spawn.spawn_enemy(player, beacon)




func _on_timer_timeout():
	spawn_enemies(4, player, beacon)
