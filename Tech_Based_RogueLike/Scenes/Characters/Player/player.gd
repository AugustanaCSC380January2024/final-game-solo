extends Character

func _process(_delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position.normalized())
	
	if mouse_direction.x > 0 && animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and !animated_sprite.flip_h:
		animated_sprite.flip_h = true
	
func get_input():
	print("get_input called")
	movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		movement_direction += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		movement_direction += Vector2.UP
	if Input.is_action_pressed("move_left"):
		movement_direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		movement_direction += Vector2.RIGHT
