extends Control

@onready var button = $Button
@onready var main_menu = get_parent().get_node("CreditsButton")


func _on_button_pressed():
	visible = false
	main_menu.grab_focus()
