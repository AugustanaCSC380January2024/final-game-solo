extends CharacterBody2D
class_name DefaultEnemy

var alive = true
var player_in_range = false
var beacon_in_range = false
var current_health = 0
var round

var hurt_sound = preload("res://Music/528816__magnuswaker__sci-fi-bass-blast.wav")
var dead_sound = preload("res://Music/SPLC-0369_FX_Oneshot_Explosion_Short_Boom.mp3")
var battery = preload("res://Scenes/battery.tscn")


@export var max_speed = 100
@export var speed = 70
var health: float
@export var player: Node2D
@export var beacon: StaticBody2D

@onready var projectile_container = get_node("ProjectileContainer")
@onready var navigation_agent = get_node("NavigationAgent2D")
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var health_bar = get_node("HealthBar")
@onready var weapon_timer = get_node("WeaponTimer")
@onready var animation_player = get_node("AnimationPlayer")
@onready var range = get_node("Range")
@onready var collision_box = get_node("CollisionShape2D")
@onready var hurt_audio_player = get_node("HurtSoundPlayer")
@onready var shoot_sound_player = $ShootSoundPlayer


var player_detection_distance = 20
var distance_offset = 64
var beacon_location = Vector2.ZERO

func _ready():
	health_bar.max_value = health
	set_health_bar()
	beacon_location = beacon.global_position + Vector2(randf_range(-10,10),randf_range(-10,10))
	hurt_audio_player.stream = hurt_sound
	

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
		if (!((beacon.global_position.x - distance_offset <= global_position.x and global_position.x <= beacon.global_position.x + distance_offset) and (beacon.global_position.y - distance_offset <= global_position.y and global_position.y <= beacon.global_position.y + distance_offset)) || player_in_range):
			#print("I SHOULD BE SLIDING")
			move_and_slide()
			if !animation_player.is_playing():
				update_animations(direction)
		#else:
			#print("x distance = " + str(x_distance_from_beacon))
			#print("y distance = " + str(y_distance_from_beacon))

func make_path():
	if alive:
		var x_distance_from_beacon = abs(beacon.global_position.x - global_position.x)
		var y_distance_from_beacon = abs(beacon.global_position.y - global_position.y)
		if player_in_range:
			navigation_agent.target_position = player.global_position
		else:
			if x_distance_from_beacon > distance_offset || y_distance_from_beacon > distance_offset:
				
				navigation_agent.target_position = beacon.global_position + Vector2(randf_range(-10,10),randf_range(-10,10))
		
func _on_timer_timeout():
	make_path()
	
func update_animations(direction):
	if alive:
		if direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

func take_damage(damage):
	if alive:
		current_health += damage
		hurt_audio_player.play()
		set_health_bar()
		scale += Vector2(.01, .01)
		if current_health >= health:
			die()

func die():
		alive = false
		collision_box.disabled = true
		animation_player.stop()
		velocity = Vector2.ZERO
		health_bar.visible = false
		animation_player.play("die")
		await animation_player.animation_finished
		hurt_audio_player.stream = dead_sound
		hurt_audio_player.play()
		await hurt_audio_player.finished
		var spawner= get_parent()
		for num in range(0, round*10):
			if randi() % 2:
				var battery_instance = battery.instantiate()
				spawner.add_child(battery_instance)
				battery_instance.global_position = global_position + Vector2(randf_range(-10,10), randf_range(-10,10))
		#free()
		queue_free()

func set_health_bar():
	health_bar.max_value = health
	health_bar.value = current_health

func _on_range_body_entered(body):
	if body.is_in_group("player"):
		player = body
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
		if !beacon_in_range:
			weapon_timer.stop()
	elif body.is_in_group("beacon"):
		beacon_in_range = false
		if !player_in_range:
			weapon_timer.stop()

func shoot(body):
	if alive:
		animation_player.play("shoot")
		await animation_player.animation_finished

func set_health(new_health):
	health = new_health




