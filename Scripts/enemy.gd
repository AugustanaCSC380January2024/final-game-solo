extends CharacterBody2D

@export var health = 2 

var dead = false

const speed = 70

@export var player: Node2D

@onready var navigation_agent := $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar

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
