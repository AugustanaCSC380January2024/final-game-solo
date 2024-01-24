extends DefaultEnemy

var energy_wave_scene = preload("res://Scenes/Projectiles/energy_wave.tscn")

var base_damage = 10

func _ready():
	#shoot_sound_player.stream()
	health = 20
	speed = 10
	base_scale = 1.2
	max_size = Vector2(2,2)
	super._ready()

func shoot(body):
	super.shoot(body)
	if alive:
		var wave = generate_wave(body)
		projectile_container.add_child(wave)
		shoot_sound_player.play()



func _on_weapon_timer_timeout():
	if player_in_range:
		shoot(player)
	elif beacon_in_range:
		shoot(beacon)

func generate_wave(body):
	var energy_wave = energy_wave_scene.instantiate()
	energy_wave.global_position = global_position
	energy_wave.direction = -body.global_position.direction_to(global_position)
	energy_wave.damage += base_damage + current_health
	return energy_wave
