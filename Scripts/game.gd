extends Node2D

@onready var level = $Level/SpawnAreas
@onready var player = get_node("Player")
@onready var beacon = get_node("Beacon")
@onready var spawn_timer = $SpawnTimer


var round = 1
var first_round_enemy_count = 4
var scaling_difficulty = 1
var round_ongoing = false
var done_spawning = false

var spawn_areas = []

func _ready():
	get_spawn_areas()
	

func _process(delta):
	if Input.is_action_just_pressed("temp_start_round"):
		start_round()
	if done_spawning:
		check_for_living_enemies()
	

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
	done_spawning = true
	print("Done Spawning")

func _on_timer_timeout():
	#spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon)
	pass

func round_complete():
	scaling_difficulty += scaling_difficulty * .5
	done_spawning = false
	round += 1
	print("Round Complete")

func start_round():
	round_ongoing = true
	spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon)
	
func test_connection():
	print("Connection Working")

func check_for_living_enemies():
	if done_spawning:
		var all_dead = true
		for spawner in spawn_areas:
			if spawner.get_tree().get_nodes_in_group("enemy").size() > 0:
				all_dead = false
		if all_dead:
			round_complete()
