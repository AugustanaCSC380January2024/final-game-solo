extends Control

var crosshair = load("res://Assets/crosshair111.png")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		change_pause_state()

func change_pause_state():
	if !get_tree().paused:
		Input.set_custom_mouse_cursor(null)
	else:
		Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible




func _on_resume_pressed():
	change_pause_state()


func _on_quit_pressed():
	get_tree().quit()
