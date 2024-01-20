extends Node2D

var crosshair = preload("res://Assets/Sprites/crosshair111.png")

@onready var level = $Level/SpawnAreas
@onready var player = get_node("Player")
@onready var beacon = get_node("Beacon")
@onready var spawn_timer = $SpawnTimer
@onready var round_start_label = $CanvasLayer/RoundStartLabel
@onready var round_label_timer = $CanvasLayer/RoundStartLabel/RoundLabelTimer
@onready var press_e_to_start_label = $"CanvasLayer/Press E to start"
@onready var beacon_sprite = $Beacon/AnimatedSprite2D
@onready var audio_stream_player = $RoundMusicPlayer
@onready var round_over_player = $RoundOverPlayer

signal update_battery_display
signal update_beacon_health_bar_max
signal update_beacon_health_bar

var round = 1
var first_round_enemy_count = 4
var scaling_difficulty = 1
var round_ongoing = false
var done_spawning = false
var player_in_start_region = false

var batteries = 0

var spawn_areas = []

func _ready():
	beacon.beacon_take_damage.connect(beacon_take_damage)
	player.battery_collected.connect(add_battery)
	update_beacon_max_label()
	get_spawn_areas()
	Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))
	

func _process(delta):
	if player_in_start_region && !round_ongoing && !round_start_label.visible:
		press_e_to_start_label.visible = true
		if Input.is_action_just_pressed("interact"):
			start_round()
	else:
		press_e_to_start_label.visible = false
	if Input.is_action_just_pressed("temp_start_round"):
		start_round()
	if done_spawning:
		check_for_living_enemies()
	

func get_spawn_areas():
	for spawn_area in level.get_children():
		spawn_areas.append(spawn_area)

func clear_spawn_area():
	spawn_areas.clear()
	
func spawn_enemies(amount, player, beacon, scaling_difficulty):
	for enemy_num in amount:
		spawn_timer.start(randf() * 5)
		await spawn_timer.timeout
		var random_spawn = spawn_areas.pick_random()
		random_spawn.spawn_enemy(player, beacon, scaling_difficulty)
		print("Spawning")
	done_spawning = true
	print("Done Spawning")

func _on_timer_timeout():
	#spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon)
	pass

func round_complete():
	round_over_player.stream = load("res://Music/short-round-110940.mp3")
	round_over_player.play()
	audio_stream_player.stop()
	scaling_difficulty += scaling_difficulty * .5
	done_spawning = false
	round += 1
	round_ongoing = false
	beacon_sprite.play("off")
	round_start_label.text = "Round Complete"
	round_start_label.visible = true
	round_label_timer.start(4)
	await round_label_timer.timeout
	round_start_label.visible = false
	print("Round Complete")

func start_round():
	if !round_ongoing:
		audio_stream_player.stream = load("res://Music/Automation (Synthwave).wav")
		audio_stream_player.play()
		round_ongoing = true
		beacon_sprite.play("on")
		round_start_label.text = "Round " + str(round)
		round_start_label.visible = true
		round_label_timer.start()
		await round_label_timer.timeout
		round_start_label.visible = false
		spawn_enemies(first_round_enemy_count * scaling_difficulty, player, beacon, scaling_difficulty)
	
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


func _on_start_round_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_start_region = true


func _on_start_round_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_start_region = false

func add_battery():
	print("battery added")
	batteries += 1
	update_battery_display.emit(batteries)

func beacon_take_damage():
	update_beacon_health()
	if beacon.current_health >= beacon.max_health:
		game_over()

func update_beacon_max_label():
	update_beacon_health_bar_max.emit(beacon.max_health)

func update_beacon_health():
	update_beacon_health_bar.emit(beacon.current_health)
	
func game_over():
	print("Game Over")
