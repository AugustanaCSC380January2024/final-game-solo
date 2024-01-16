extends Area2D

@export var direction: Vector2
@export var speed: float = 100


func _physics_process(delta):
	position += direction * speed * delta
	


func _on_body_entered(body):
	queue_free()
