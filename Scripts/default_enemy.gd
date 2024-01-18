extends CharacterBody2D
class_name DefaultEnemy

var alive = true
var player_in_range = false
var beacon_in_range = false
var current_health = 0


@export var max_speed = 100
@export var speed = 70
@export var health = 2
@export var player: Node2D
@export var beacon: StaticBody2D

@onready var projectile_container = get_node("ProjectileContainer")
@onready var navigation_agent = get_node("NavigationAgent2D")
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var health_bar = get_node("HealthBar")
@onready var weapon_timer = get_node("WeaponTimer")
@onready var animation_player = get_node("AnimationPlayer")
@onready var range = get_node("Range")

var player_detection_distance = 20
var distance_offset = 20.0

func _ready():
	health_bar.max_value = health
	set_health_bar()

func _physics_process(delta: float):
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if direction.x < 0:
		animated_sprite.flip_h = true
	if direction.x > 0:
		animated_sprite.flip_h = false
	velocity = direction * speed
	if alive:
		var x_distance_from_beacon = abs(beacon.global_position.x - global_position.x)
		var y_distance_from_beacon = abs(beacon.global_position.y - global_position.y)
		if ((x_distance_from_beacon <= distance_offset || y_distance_from_beacon <= distance_offset) || player_in_range):
			move_and_slide()
			if !animation_player.is_playing():
				update_animations(direction)

func make_path():
	if alive:
		var x_distance_from_beacon = abs(beacon.global_position.x - global_position.x)
		var y_distance_from_beacon = abs(beacon.global_position.y - global_position.y)
		if player_in_range:
			navigation_agent.target_position = player.global_position
		else:
			if x_distance_from_beacon > distance_offset || y_distance_from_beacon > distance_offset:
				navigation_agent.target_position = beacon.global_position
		
func _on_timer_timeout():
	make_path()
	
func update_animations(direction):
	if alive:
		if direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

func take_damage(damage):
	current_health += damage
	set_health_bar()
	if current_health >= health:
		die()

func die():
		alive = false
		animation_player.stop()
		velocity = Vector2.ZERO
		health_bar.visible = false
		animation_player.play("die")
		await animation_player.animation_finished
		queue_free()

func set_health_bar():
	health_bar.value = current_health

func _on_range_body_entered(body):
	if body.is_in_group("player"):
		print("player entered")
		player_in_range = true
		weapon_timer.start()
	elif body.is_in_group("beacon"):
		print("beacon entered")
		beacon_in_range = true
		weapon_timer.start()

func _on_range_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		weapon_timer.stop()
	elif body.is_in_group("beacon"):
		beacon_in_range = false
		weapon_timer.stop()

func shoot(body):
	if alive:
		animation_player.play("shoot")
		await animation_player.animation_finished






