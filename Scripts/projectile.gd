extends Area2D

@export var direction: Vector2
@export var speed: float = 150
@export var sprite_in: AnimatedSprite2D
@export var damage: float = 1

@onready var animated_sprite = $AnimatedSprite2D

#func _ready():
	#animated_sprite.animation = sprite_in

func _physics_process(delta):
	animated_sprite.look_at(direction)
	position += direction * speed * delta
	


func _on_body_entered(body):
	if body.is_in_group("enemy") || body.is_in_group("player") || body.is_in_group("beacon"):
		body.take_damage(damage)
	queue_free()
