extends CharacterBody2D

const speed = 70

@export var player: Node2D

@onready var navigation_agent := $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float):
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if direction.x < 0:
		animated_sprite.flip_h = true
	if direction.x > 0:
		animated_sprite.flip_h = false
	velocity = direction * speed
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
