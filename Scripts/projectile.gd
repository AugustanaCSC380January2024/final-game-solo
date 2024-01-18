extends Area2D

@export var direction: Vector2
@export var speed: float = 150
@export var sprite_in: AnimatedSprite2D
var damage: float
var friendly = false

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	animated_sprite.look_at(direction)
	position += direction * speed * delta
	


func _on_body_entered(body):
	if body.is_in_group("enemy") || body.is_in_group("player") || (body.is_in_group("beacon") && !friendly):
		body.take_damage(damage)
	queue_free()
