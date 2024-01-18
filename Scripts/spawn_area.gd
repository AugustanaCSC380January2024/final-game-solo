extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var centerpos = collision_shape_2d.position + self.position

