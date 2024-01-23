extends Node2D

var crosshair = preload("res://Assets/Sprites/crosshair111.png")
var game_over_sound = preload("res://Assets/Sounds/BOS_DBN_145_FX_Impact_Loop_Profit_F.wav")
var player_scene = preload("res://Scenes/player.tscn")

@onready var level = $Level/SpawnAreas
@onready var player = get_node("Player")
@onready var beacon = get_node("Beacon")
@onready var spawn_timer = $SpawnTimer
@onready var round_start_label = $CanvasLayer/RoundStartLabel
@onready var round_label_timer = $CanvasLayer/RoundStartLabel/RoundLabelTimer
@onready var press_e_to_start_label = $"CanvasLayer/Press E to start"
@onready var open_store_label = $CanvasLayer/OpenStoreLabel
@onready var ambient_music_player = $AmbientMusicPlayer

@onready var beacon_sprite = $Beacon/AnimatedSprite2D
@onready var audio_stream_player = $RoundMusicPlayer
@onready var round_over_player = $RoundOverPlayer
@onready var respawner = $CanvasLayer/Respawner
@onready var store_ui = $CanvasLayer/StoreUI
@onready var win_screen = $CanvasLayer/WinScreen
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var player_cam = $PlayerCam

signal update_battery_display
signal update_beacon_health_bar_max
signal update_beacon_health_bar

var round = 1
var first_round_enemy_count = 4
var scaling_difficulty = 1
var round_ongoing = false
var done_spawning = false
var player_in_start_region = false
var player_in_store_region = false

var batteries = 0

var spawn_areas = []
var two_players = false

func _ready():
	player.can_shoot = false
	beacon.beacon_take_damage.connect(beacon_take_damage)
	player.battery_collected.connect(add_battery)
	player.player_die.connect(respawn_player)
	pause_menu.add_player_2.connect(start_coop)
	store_ui.spent_batteries.connect(set_batteries)
	update_beacon_max_label()
	get_spawn_areas()
	Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))
	set_batteries(1000)
	

func _process(delta):
	update_player_cam()
	if player_in_start_region && !round_ongoing && !round_start_label.visible:
		press_e_to_start_label.visible = true
		if Input.is_action_just_pressed("interact"):
			start_round()
	else:
		press_e_to_start_label.visible = false
	if player_in_store_region && !round_ongoing && !store_ui.visible:
		open_store_label.visible = true
		if Input.is_action_just_pressed("interact"):
			open_shop()
			store_ui.damage_button.grab_focus()
			Input.set_custom_mouse_cursor(null)
	else:
		open_store_label.visible = false
	if done_spawning:
		check_for_living_enemies()
	if $CanvasLayer/Introduction.visible:
		Input.set_custom_mouse_cursor(null)
		
	
	

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
	ambient_music_player.play()
	if round == 11:
		win_screen.visible = true

func start_round():
	if !round_ongoing:
		ambient_music_player.stop()
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

func set_batteries(num:int):
	batteries = num
	update_battery_display.emit(batteries)
	print("set_batteries run")

func beacon_take_damage():
	update_beacon_health()
	if beacon.current_health >= beacon.max_health:
		game_over()

func update_beacon_max_label():
	update_beacon_health_bar_max.emit(beacon.max_health)

func update_beacon_health():
	update_beacon_health_bar.emit(beacon.current_health)
	
func game_over():
	var explosion_scene = load("res://Scenes/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	var player_cam = $Player/Camera2D
	player_cam.global_position = beacon.global_position
	audio_stream_player.stop()
	ambient_music_player.stream = game_over_sound
	ambient_music_player.play()
	await get_tree().create_timer(1.65).timeout
	beacon.add_child(explosion)
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func respawn_player():
	var respawn_timer = $"CanvasLayer/Respawner/Respawn Timer"
	var respawn_pos = $Level/PlayerSpawn
	var player_health_bar = $Player/UI/HUD/ProgressBar
	var player_cam = $Player/Camera2D
	print("Respawning Player")
	player.global_position = Vector2(1000,1000)
	respawner.visible = true
	player_cam.global_position = beacon.global_position
	respawner.respawn()
	await respawn_timer.timeout
	player.global_position = respawn_pos.global_position
	player.alive = true
	player.health = player.max_health
	player.visible = true
	player_cam.global_position = player.global_position
	player_health_bar.value = player.health
	respawner.visible = false
	
	


func _on_store_open_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_store_region = true
		if !round_ongoing:
			$Store/AnimatedSprite2D.play("open")


func _on_store_open_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_store_region = false
		store_ui.visible = false
		Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))
		player.can_shoot = true
		$Store/AnimatedSprite2D.play("closed")

func open_shop():
	store_ui.visible = true
	player.can_shoot = false


func _on_introduction_visibility_changed():
	Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))
	


func _on_introduction_hidden():
	player.can_shoot = true
	ambient_music_player.play()

func start_coop():
	two_players = true
	var player2 = player_scene.instantiate()
	player2.player_id = 2
	player2.name = "Player2"
	add_child(player2)
	player2.global_position = beacon.global_position + Vector2(0, 20)
	
func update_player_cam():
	if two_players:
		var min_zoom = .5
		var max_zoom = 2.5
		var player2 = get_node("Player2")
		player_cam.global_position = (player.global_position + player2.global_position) * .5
		var distance = player.global_position.distance_to(player2.global_position)
		var desired_zoom = distance /1000
		var zoom_factor = max(min_zoom,max_zoom,desired_zoom)
		player_cam.zoom = Vector2(zoom_factor, zoom_factor)
	else:
		player_cam.global_position = player.global_position
		player_cam.zoom = Vector2(2.5,2.5)
	
