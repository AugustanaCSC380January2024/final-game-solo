extends Node2D

@onready var progress = $Progress
@onready var fire_rate_timer = $FireRateTimer


func _process(delta):
	progress.value = fire_rate_timer.time_left
