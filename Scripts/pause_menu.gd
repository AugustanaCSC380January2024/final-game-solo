extends Control

var save_path = "user://aiovercharged.save"

var crosshair = load("res://Assets/Sprites/crosshair111.png")
@onready var resume = $Resume
@onready var add_player_2_button = $AddPlayer2
@onready var player = get_parent().get_parent().get_node("Player")
@onready var beacon = get_parent().get_parent().get_node("Beacon")
@onready var store = get_parent().get_parent().get_node("CanvasLayer").get_node("StoreUI")
@onready var game = get_parent().get_parent()

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


func _on_save_pressed():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(player.max_health)
	file.store_var(player.bullet_damage)
	file.store_var(player.bullet_speed)
	file.store_var(player.fire_rate)
	file.store_var(player.bullet_size)
	file.store_var(game.round)
	file.store_var(game.batteries)
	file.store_var(beacon.current_health)
	
	pass # Replace with function body.
