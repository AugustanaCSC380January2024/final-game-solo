extends Control

@onready var respawn_timer = $"Respawn Timer"
@onready var respawn_label = $RespawnLabel
@onready var interval = $Interval

@export var respawn_time = 10

signal respawned

func respawn():
	for time in range(10,0,-1):
		print(str(time))
		update_label(time)
		interval.start()
		await interval.timeout
	respawn_timer.start()
	update_label(0)

func update_label(time):
	respawn_label.text = "RESPAWNING IN:\n" + str(time)

