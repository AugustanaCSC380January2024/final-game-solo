extends Control

@onready var battery_count = $BatteryCount

func _ready():
	var gamer = get_parent().get_parent()
	print(gamer)
	gamer.update_battery_display.connect(set_battery_label)

func set_battery_label(num_batteries):
	battery_count.text = str(num_batteries)
