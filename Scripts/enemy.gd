extends DefaultEnemy

var lazer_ball_scene = preload("res://Scenes/Projectiles/lazer_ball.tscn")

var base_damage = 2

func _ready():
	health = 2
	super._ready()

func shoot(body):
	super.shoot(body)
	if alive:
		var projectile = generate_projectile(body)
		projectile_container.add_child(projectile)


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


