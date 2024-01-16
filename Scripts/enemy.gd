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

var energy_orb_scene = preload("res://Scenes/energy_orb.tscn")

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
	if (!dead):
		move_and_slide()
		update_animations(direction)
	
func make_path():
	navigation_agent.target_position = player.global_position + Vector2(5,5)


func _on_timer_timeout():
	make_path()
	
func update_animations(direction):
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
		
func take_damage():
	health -= 1
	health_bar.value = health
	if health == 0:
		dead = true
		velocity = Vector2.ZERO
		animated_sprite.play("die")
		await get_tree().create_timer(.7).timeout
		queue_free()
		
func set_health_bar():
	health_bar.value = health


func _on_range_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		#weapon_timer.start()

func shoot(body):
	print("Shooting")
	var energy_orb = energy_orb_scene.instantiate()
	energy_orb.set_collision_mask_value(3, false)
	energy_orb.set_collision_mask_value(2, true)
	energy_orb.global_position = global_position
	energy_orb.position = position
	energy_orb.direction = -body.global_position.direction_to(position)
	projectile_container.add_child(energy_orb)


func _on_range_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		#weapon_timer.stop()


func _on_weapon_timer_timeout():
	if player_in_range:
		shoot(player)
