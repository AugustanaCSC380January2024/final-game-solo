extends StaticBody2D

@onready var top_light = $Lights/TopLight
@onready var bottom_light = $Lights/BottomLight

var rotation_speed = 5

func _ready():
	bottom_light.rotation = 0
func _physics_process(delta):
	top_light.rotate(rotation_speed*delta)
	bottom_light.rotate(rotation_speed*delta)


func _on_life_span_timeout():
	queue_free()
