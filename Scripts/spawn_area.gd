extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var small_enemy = preload("res://Scenes/enemy.tscn")
var large_enemy = preload("res://Scenes/large_enemy.tscn")

var enemy_array = []

func _ready():
	enemy_array.append(small_enemy)
	enemy_array.append(large_enemy)

func spawn_enemy(player, beacon):
	print("enemy spawned")
	var spawnable_enemy = enemy_array.pick_random().instantiate()
	spawnable_enemy.player = player
	spawnable_enemy.beacon = beacon
	add_child(spawnable_enemy)

