extends CharacterBody2D

@export var max_health = 20
@export var health = 20

@export var speed = 100

@export var player_id = 1

var bullet_damage: float = 1.0
var bullet_speed: float = 150
var fire_rate: float = 2.0
var bullet_size:float = 1

signal battery_collected
signal player_die

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $UI/HUD/ProgressBar
@onready var animation_player = $AnimationPlayer
@onready var shot_player = $ShotPlayer
@onready var battery_player = $BatteryPlayer
@onready var weapon_cooldown = $WeaponCooldown
@onready var hurt_player = $HurtPlayer
@onready var cooldown_progress = $CooldownProgress
@onready var crosshair = $Crosshair
@onready var player_2_health_bar = $UI/HUD/ProgressBar

var shoot_sound = preload("res://Assets/Sounds/ESM_GW_gun_one_shot_hi_tech_machine_single_shot_4_energy_heavy_bass_short_1.wav")
var battery_sound = preload("res://Music/CoinFlipTossRing_S08FO.689.wav")
var death_sound = preload("res://Assets/Sounds/ESM_Planet_Absorb_Game_FX_1Pick_Up_Robotic_Technology_Hi_Tech_Game_Tone_Science_UFO_Space_Processed_Glitch_Hybrid_Sci_fi.wav")

var hurt_sounds = []
var hurt_sound_1 = preload("res://Assets/Sounds/Hurt/ESM_ACV_Vocals_male_pain_heavy_damage_painful_injury_02.wav")
var hurt_sound_2 = preload("res://Assets/Sounds/Hurt/ESM_ACV_Vocals_male_pain_medium_injury_tonal_shift_03.wav")
var hurt_sound_3 = preload("res://Assets/Sounds/Hurt/ESM_High_Elf_Vocal_Pain_Vocal_Ouch_Ahh_Male_Voice.wav")
var hurt_sound_4 = preload("res://Assets/Sounds/Hurt/ESM_Wizard_Pain_Vocal_Hurt_Uhh_Male_Voice_Old_Man.wav")
var animation_playing = false

var energy_orb_container
var alive = true
var cooldown = false
var can_shoot: bool = true
var look_vector = Vector2.ZERO
var controller_aim = false

var energy_orb_scene = preload("res://Scenes/Projectiles/energy_orb.tscn")

func _ready():
	hurt_sounds.append(hurt_sound_1)
	hurt_sounds.append(hurt_sound_2)
	hurt_sounds.append(hurt_sound_3)
	hurt_sounds.append(hurt_sound_4)
	energy_orb_container = get_node("EnergyOrbContainer")
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
	shot_player.stream = shoot_sound
	battery_player.stream = battery_sound
	cooldown_progress.max_value = weapon_cooldown.wait_time
	if player_id == 2:
		player_2_health_bar.global_position += Vector2(0,60)

func _process(delta):
	if alive:
		if Input.is_action_just_pressed("shoot_%s" % [player_id]):# && controller_aim:
			shoot()
	cooldown_progress.value = weapon_cooldown.time_left

func _physics_process(delta):
	if alive:
		get_input()
		move_and_slide()
		if player_id == 2:
			aim()
		
func aim():
	look_vector.x = -(Input.get_action_strength("look_right_%s" % [player_id]) - Input.get_action_strength("look_left_%s" % [player_id]))
	if look_vector.x > 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	look_vector.y = (Input.get_action_strength("look_up_%s" % [player_id]) - Input.get_action_strength("look_down_%s" % [player_id]))
	if look_vector != Vector2.ZERO:
		print("TURE")
		crosshair.visible = true
		crosshair.position = -(look_vector.normalized()*100)
		controller_aim = true
	else:
		crosshair.visible = false
		controller_aim = false
	
func get_input():
	var input_direction = Input.get_vector("move_left_%s" % [player_id], "move_right_%s" % [player_id], "move_up_%s" % [player_id], "move_down_%s" % [player_id])
	if player_id == 2:
		if global_position.x > get_global_mouse_position().x:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	velocity = input_direction * speed
	if !animation_player.is_playing():
		update_animations(input_direction)
	
func update_animations(direction):
	if direction == Vector2.ZERO:
		animated_sprite.play("idle_%s" % [player_id])
	else:
		animated_sprite.play("walking_%s" % [player_id])
		
func shoot():
	if !cooldown && can_shoot:
		if player_id == 2 && controller_aim == false:
			return
		cooldown = true
		weapon_cooldown.start()
		cooldown_progress.visible = true
		var energy_orb = energy_orb_scene.instantiate()
		energy_orb.damage = bullet_damage
		energy_orb.speed = bullet_speed
		energy_orb.scale = Vector2(bullet_size,bullet_size)
		energy_orb.friendly = true
		shot_player.play()
		animation_player.play("shoot_%s" % [player_id])
		energy_orb.global_position = global_position
		energy_orb.position = position
		if controller_aim && player_id == 2:
			energy_orb.direction = -crosshair.global_position.direction_to(position)
		else:
			energy_orb.direction = -get_global_mouse_position().direction_to(position)
		energy_orb_container.add_child(energy_orb)

func take_damage(damage):
	health -= damage
	$UI/HUD/ProgressBar.value = health
	hurt_player.stream = hurt_sounds.pick_random()
	hurt_player.play()
	if health <= 0:
		die()

func die():
	if alive:
		hurt_player.stream = death_sound
		hurt_player.play()
		print("Dead")
		alive = false
		velocity = Vector2.ZERO
		#animation_player.play("die_%s" % [player_id])
		#await animation_player.animation_finished
		print("DONE")
		visible = false
		player_die.emit(self)



func _on_coin_collection_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("battery"):
		battery_collected.emit()
		battery_player.play()
		area.queue_free()


func _on_weapon_cooldown_timeout():
	cooldown = false
	cooldown_progress.visible = false

func upgrade_damage():
	bullet_damage += bullet_damage - bullet_damage/2.0
	bullet_size += .1

func upgrade_weapon_cooldown():
	if weapon_cooldown.wait_time > 0:
		weapon_cooldown.wait_time -= .1
		cooldown_progress.max_value = weapon_cooldown.wait_time

func upgrade_bullet_speed():
	bullet_speed += 10
