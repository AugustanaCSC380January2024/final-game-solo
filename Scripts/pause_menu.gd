extends Control

var crosshair = load("res://Assets/Sprites/crosshair111.png")
@onready var resume = $Resume
@onready var add_player_2_button = $AddPlayer2

signal add_player_2

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		change_pause_state()
		resume.grab_focus()

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


func _on_main_menu_pressed():
	change_pause_state()
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_add_player_2_pressed():
	add_player_2.emit()
	add_player_2_button.queue_free()
	change_pause_state()
