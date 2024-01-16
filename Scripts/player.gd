extends CharacterBody2D

@export var speed = 100

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	get_input()
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if global_position.x > get_global_mouse_position().x:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	velocity = input_direction * speed
	update_animations(input_direction)
	
func update_animations(direction):
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walking")
	
