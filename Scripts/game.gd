extends Node2D

@onready var level = $Level/SpawnAreas
@onready var player = get_node("Player")
@onready var beacon = get_node("Beacon")
@onready var spawn_timer = $SpawnTimer

var round = 1
var first_round_enemy_count = 4
var scaling_difficulty = 1
var round_ongoing = false

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
		spawn_timer.start(randf() * 10)
		await spawn_timer.timeout
		var random_spawn = spawn_areas.pick_random()
		random_spawn.spawn_enemy(player, beacon)
		print("Spawning")

func _on_timer_timeout():
	spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon)

func round_complete():
	scaling_difficulty += scaling_difficulty * .5

func start_round():
	spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon)
	
