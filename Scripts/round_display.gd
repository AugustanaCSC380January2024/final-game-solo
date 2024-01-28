extends Control

@onready var label = $Label


func set_round_label(round_num):
	label.text = "Round " + str(round_num)
