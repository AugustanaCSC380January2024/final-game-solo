extends Projectile
 

func _physics_process(delta):
	animated_sprite.look_at(direction)
	position = direction *Vector2(10,10)


func _on_lifetime_timeout():
	queue_free()
