extends Control

@onready var damage_button = $DamageButton
@onready var bullet_speed_button = $BulletSpeedButton
@onready var fire_rate_button = $FireRateButton
@onready var heal_player_button = $HealPlayerButton
@onready var heal_beacon_button = $HealBeaconButton
@onready var batteries = self.get_parent().get_parent().batteries
@onready var crosshair = self.get_parent().get_parent().crosshair
@onready var player = self.get_parent().get_parent().get_node("Player")
@onready var beacon = self.get_parent().get_parent().get_node("Beacon")

var increase_rate = 1.5
signal spent_batteries


func _on_damage_button_pressed():
	get_batteries()
	if batteries >= int(damage_button.text):
		spend(int(damage_button.text))
		damage_button.text = str(int(int(damage_button.text) * increase_rate))
		player.upgrade_damage()
		if is_two_player():
			self.get_parent().get_parent().get_node("Player2").upgrade_damage()


func _on_bullet_speed_button_pressed():
	get_batteries()
	if batteries >= int(bullet_speed_button.text):
		spend(int(bullet_speed_button.text))
		bullet_speed_button.text = str(int(int(bullet_speed_button.text) * increase_rate))
		player.upgrade_bullet_speed()
		if is_two_player():
			self.get_parent().get_parent().get_node("Player2").upgrade_bullet_speed()

func _on_fire_rate_button_pressed():
	get_batteries()
	if batteries >= int(fire_rate_button.text):
		spend(int(fire_rate_button.text))
		fire_rate_button.text = str(int(int(fire_rate_button.text) * increase_rate))
		player.upgrade_weapon_cooldown()
		if is_two_player():
			self.get_parent().get_parent().get_node("Player2").upgrade_weapon_cooldown()

func _on_heal_player_button_pressed():
	get_batteries()
	if batteries >= int(heal_player_button.text):
		spend(int(heal_player_button.text))
		heal_player_button.text = str(int(int(heal_player_button.text) * increase_rate))
		player.max_health = player.max_health + player.max_health / 10.0
		player.health += player.max_health / 10.0
		if is_two_player():
			self.get_parent().get_parent().get_node("Player2").max_health = player.max_health


func _on_heal_beacon_button_pressed():
	get_batteries()
	if batteries >= int(heal_beacon_button.text):
		spend(int(heal_beacon_button.text))
		heal_beacon_button.text = str(int(int(heal_beacon_button.text) * increase_rate))
		beacon.current_health -= beacon.max_health / 10.0
		if beacon.current_health < 0:
			beacon.current_health = 0

func spend(cost):
	get_batteries()
	var new_total = batteries - cost
	spent_batteries.emit(new_total)


func _on_close_pressed():
	visible = false
	Input.set_custom_mouse_cursor(crosshair,0,Vector2(32,32))

func get_batteries():
	batteries = self.get_parent().get_parent().batteries

func is_two_player():
	return self.get_parent().get_parent().two_players
