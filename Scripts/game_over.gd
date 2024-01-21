extends Control

@onready var play_again = $PlayAgain
@onready var main_menu = $MainMenu

func _ready():
	Input.set_custom_mouse_cursor(null)

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
