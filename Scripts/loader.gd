extends Node

var max_health
var bullet_damage
var bullet_speed
var fire_rate
var bullet_size
var round
var batteries

func has_save():
	if max_health != null:
		return true
	else:
		return false
	
