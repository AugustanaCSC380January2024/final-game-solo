extends DefaultEnemy

var energy_wave_scene = preload("res://Scenes/Projectiles/energy_wave.tscn")

var base_damage = 50

func _ready():
	shoot_sound_player.stream = preload("res://Assets/Sounds/Shoot/FireballPassByHeavy_SFXB.63.wav")
	health = 20
	speed = 10
	base_scale = 1.2
	max_size = Vector2(2,2)
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	if moving && !$FootstepPlayer.playing:
		$FootstepPlayer.play()

func shoot(body):
	super.shoot(body)
	if alive:
		var wave = generate_wave(body)
		projectile_container.add_child(wave)
		shoot_sound_player.play()

func make_path():
	if alive:
		var x_distance_from_beacon = abs(beacon.global_position.x - global_position.x)
		var y_distance_from_beacon = abs(beacon.global_position.y - global_position.y)
		if x_distance_from_beacon > distance_offset || y_distance_from_beacon > distance_offset:
			navigation_agent.target_position = beacon.global_position + Vector2(randf_range(-10,10),randf_range(-10,10))

func _on_weapon_timer_timeout():
	if beacon_in_range:
		shoot(beacon)

func generate_wave(body):
	var energy_wave = energy_wave_scene.instantiate()
	energy_wave.global_position = global_position
	energy_wave.direction = -body.global_position.direction_to(global_position)
	energy_wave.damage += base_damage + current_health
	return energy_wave
