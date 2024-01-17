extends "res://Scripts/enemy.gd"

var lazer_ball_big_scene = preload("res://Scenes/Projectiles/lazer_ball_big.tscn")
@onready var animation_player_big = $AnimationPlayer



func shoot(body):
	if !stopped:
		stop_movement()
		super.shoot(body)
		await animation_player_big.animation_finished
		stop_movement()
	
func generate_projectile(body):
	var lazer_ball_big = lazer_ball_big_scene.instantiate()
	lazer_ball_big.global_position = global_position
	lazer_ball_big.position = position
	lazer_ball_big.direction = -body.global_position.direction_to(position)
	return lazer_ball_big
	
	
