extends DefaultEnemy

var lazer_ball_scene = preload("res://Scenes/Projectiles/lazer_ball.tscn")

var base_damage = 2

func _ready():
	shoot_sound_player.stream = preload("res://Music/ESM_FVESK_fx_foley_repair_work_shop_laser_ufo_high_energy_beams_neon_high_2.wav")
	health = 2
	super._ready()

func shoot(body):
	super.shoot(body)
	if alive && get_tree().get_first_node_in_group("siren") == null:
		var projectile = generate_projectile(body)
		projectile_container.add_child(projectile)
		shoot_sound_player.play()


func _on_weapon_timer_timeout():
	if player_in_range:
		shoot(player)
	elif beacon_in_range:
		shoot(beacon)
		

func generate_projectile(body):
	var lazer_ball = lazer_ball_scene.instantiate()
	lazer_ball.global_position = global_position
	lazer_ball.direction = -body.global_position.direction_to(global_position)
	lazer_ball.damage += base_damage + current_health
	return lazer_ball


