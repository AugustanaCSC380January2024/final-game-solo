extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var small_enemy = preload("res://Scenes/enemy.tscn")
var large_enemy = preload("res://Scenes/large_enemy.tscn")

var enemy_array = []

func _ready():
	enemy_array.append(small_enemy)
	enemy_array.append(large_enemy)

func spawn_enemy(player, beacon, scaling_difficulty):
	var spawnable_enemy = enemy_array.pick_random().instantiate()
	spawnable_enemy.scale = Vector2(.6,.6)
	spawnable_enemy.base_damage = spawnable_enemy.base_damage * (1 + .1) ** scaling_difficulty
	spawnable_enemy.player = player
	spawnable_enemy.beacon = beacon
	spawnable_enemy.round = scaling_difficulty
	add_child(spawnable_enemy)
	spawnable_enemy.health = spawnable_enemy.health * (1 + .2) ** scaling_difficulty
	print("Enemy should be spawned")

