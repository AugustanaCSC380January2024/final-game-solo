extends Control

@onready var battery_count = $BatteryCount
@onready var beacon_health_bar = $BeaconHealthBar

func _ready():
	var gamer = get_parent().get_parent()
	print(gamer)
	gamer.update_battery_display.connect(set_battery_label)
	gamer.update_beacon_health_bar_max.connect(set_max_beacon_health)
	gamer.update_beacon_health_bar.connect(set_beacon_health)

func set_battery_label(num_batteries):
	battery_count.text = str(num_batteries)
	
func set_max_beacon_health(health):
	beacon_health_bar.max_value = health
	print("Set Max value to " + str(health))
	
func set_beacon_health(health):
	beacon_health_bar.value = health
	if health >= float(beacon_health_bar.max_value) *(2/3.0):
		beacon_health_bar.modulate = Color(255,0,0)
	elif health >= float(beacon_health_bar.max_value) /3.0:
		beacon_health_bar.modulate = Color(255,208,0)
	else:
		beacon_health_bar.modulate = Color(0,158,0)
