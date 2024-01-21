extends Control
@onready var free_play = $FreePlay
@onready var main_menu = $MainMenu


func _on_free_play_pressed():
	visible = false
	self.queue_free()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
