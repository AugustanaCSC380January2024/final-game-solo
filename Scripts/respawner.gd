extends Control

@onready var respawn_timer = $"Respawn Timer"
@onready var respawn_label = $RespawnLabel
@onready var interval = $Interval
@onready var respawn_player = $RespawnPlayer

var respawn_time = 5

signal respawned

func respawn():
	for time in range(respawn_time,0,-1):
		print(str(time))
		update_label(time)
		interval.start()
		await interval.timeout
	respawn_timer.start()
	print("Started Respawn Timer")
	update_label(0)
	await respawn_timer.timeout
	respawn_player.play()
	

func update_label(time):
	respawn_label.text = "RESPAWNING IN:\n" + str(time)

