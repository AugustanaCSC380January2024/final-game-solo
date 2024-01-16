extends CharacterBody2D

var projectile_container
var dead = false
var player_in_range = false

const speed = 70

@export var health = 2 
@export var player: Node2D

@onready var navigation_agent := $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var weapon_timer = $WeaponTimer

var lazer_ball_scene = preload("res://Scenes/Projectiles/lazer_ball.tscn")

func _ready():
	projectile_container = get_node("ProjectileContainer")
	health_bar.max_value = health
	set_health_bar()

func _physics_process(delta: float):
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if direction.x < 0:
		animated_sprite.flip_h = true
	if direction.x > 0:
		animated_sprite.flip_h = false
	velocity = direction * speed
	if (!dead && (abs(player.global_position.x - global_position.x) > 30) || (abs(player.global_position.y - global_position.y) > 30)):
		move_and_slide()
		update_animations(direction)
	
func make_path():
	if !dead:
		navigation_agent.target_position = player.global_position


func _on_timer_timeout():
	make_path()
	
func update_animations(direction):
	if !dead:
		if direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
		
func take_damage(damage):
	health -= damage
	health_bar.value = health
	if health == 0:
		die()

func die():
		dead = true
		velocity = Vector2.ZERO
		animated_sprite.play("die")
		await get_tree().create_timer(.7).timeout
		queue_free()
		
func set_health_bar():
	health_bar.value = health


func shoot(body):
	print("Shooting")
	var lazer_ball = lazer_ball_scene.instantiate()
	lazer_ball.global_position = global_position
	lazer_ball.position = position
	lazer_ball.direction = -body.global_position.direction_to(position)
	projectile_container.add_child(lazer_ball)


func _on_range_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		weapon_timer.start()
		
func _on_range_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		weapon_timer.stop()


func _on_weapon_timer_timeout():
	if player_in_range:
		shoot(player)
