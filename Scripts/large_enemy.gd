extends DefaultEnemy

var lazer_ball_big_scene = preload("res://Scenes/Projectiles/lazer_ball_big.tscn")
@onready var animation_player_big = $AnimationPlayer

var base_damage = 4

func _ready():
	health = 5
	super._ready()

func shoot(body):
	super.shoot(body)
	if alive:
		var projectile = generate_projectile(body)
		projectile_container.add_child(projectile)
	
func generate_projectile(body):
	var lazer_ball_big = lazer_ball_big_scene.instantiate()
	lazer_ball_big.damage = base_damage + current_health
	lazer_ball_big.global_position = global_position
	lazer_ball_big.direction = -body.global_position.direction_to(global_position)
	return lazer_ball_big
	
func _on_weapon_timer_timeout():
	if player_in_range:
		shoot(player)
	elif beacon_in_range:
		shoot(beacon)
		
	
