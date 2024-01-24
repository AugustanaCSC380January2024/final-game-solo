extends Control

@onready var new_game = $NewGame
@onready var credits_button = $CreditsButton
@onready var quit = $Quit
@onready var credits = $Credits

var save_path = "user://aiovercharged.save"

func _ready():
	new_game.grab_focus()

func _on_play_pressed():
	Loader.load_game = false
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_credits_pressed():
	credits.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_load_game_pressed():
	if FileAccess.file_exists(save_path):
		print("file found")
		Loader.load_game = true
		var file = FileAccess.open(save_path, FileAccess.READ)
		Loader.max_health = file.get_var()
		Loader.bullet_damage = file.get_var()
		Loader.bullet_speed = file.get_var()
		Loader.fire_rate = file.get_var()
		Loader.bullet_size = file.get_var()
		Loader.round = file.get_var()
		Loader.batteries = file.get_var()
		Loader.beacon_health = file.get_var()
		Loader.damage_button = file.get_var()
		Loader.bullet_speed_button = file.get_var()
		Loader.fire_rate_button = file.get_var()
		Loader.heal_player_button = file.get_var()
		Loader.heal_beacon_button = file.get_var()
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	
	
	pass # Replace with function body.
