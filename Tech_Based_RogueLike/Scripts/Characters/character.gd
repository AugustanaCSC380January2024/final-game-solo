extends CharacterBody2D
class_name Character

const friction: float = 0.15

@export var acceleration: int = 40
@export var max_speed: int = 100

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var movement_direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, friction)
	

func move():
	movement_direction = movement_direction.normalized()
	velocity += movement_direction * acceleration
	velocity = velocity.limit_length(max_speed)
