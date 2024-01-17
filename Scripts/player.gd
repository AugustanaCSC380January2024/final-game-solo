extends CharacterBody2D

@export var health = 10

@export var speed = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $UI/HUD/ProgressBar
@onready var animation_player = $AnimationPlayer

var animation_playing = false

var energy_orb_container
var alive = true

var energy_orb_scene = preload("res://Scenes/Projectiles/energy_orb.tscn")

func _ready():
	energy_orb_container = get_node("EnergyOrbContainer")
	health_bar.max_value = health
	health_bar.value = health

func _process(delta):
	if alive:
		if Input.is_action_just_pressed("shoot"):
			shoot()

func _physics_process(delta):
	if alive:
		get_input()
		move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if global_position.x > get_global_mouse_position().x:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	velocity = input_direction * speed
	if !animation_player.is_playing():
		update_animations(input_direction)
	
func update_animations(direction):
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walking")
		
func shoot():
	var energy_orb = energy_orb_scene.instantiate()
	animation_player.play("shoot")
	energy_orb.global_position = global_position
	energy_orb.position = position
	energy_orb.direction = -get_global_mouse_position().direction_to(position)
	energy_orb_container.add_child(energy_orb)

func take_damage(damage):
	health -= damage
	$UI/HUD/ProgressBar.value = health
	if health <= 0:
		die()

func die():
	print("Dead")
	alive = false
	velocity = Vector2.ZERO
	animation_player.play("die")
	await animation_player.animation_finished
	animated_sprite.visible = false
