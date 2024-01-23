extends Control

@onready var button = $Button

func _ready():
	button.grab_focus()

func _on_button_pressed():
	visible = false
