extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		change_pause_state()

func change_pause_state():
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible




func _on_resume_pressed():
	change_pause_state()


func _on_quit_pressed():
	get_tree().quit()
