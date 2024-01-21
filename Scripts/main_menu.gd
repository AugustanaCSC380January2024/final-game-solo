extends Control

@onready var play = $Play
@onready var credits_button = $CreditsButton
@onready var quit = $Quit
@onready var credits = $Credits


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_credits_pressed():
	credits.visible = true


func _on_quit_pressed():
	get_tree().quit()
