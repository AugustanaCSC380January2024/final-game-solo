extends StaticBody2D

@onready var top_light = $Lights/TopLight
@onready var bottom_light = $Lights/BottomLight
@onready var life_span_timer = $LifeSpan
@export var life_span = 5

var rotation_speed = 5

func _ready():
	bottom_light.rotation = 0
	life_span_timer.wait_time = life_span
	life_span_timer.start()
func _physics_process(delta):
	top_light.rotate(rotation_speed*delta)
	bottom_light.rotate(rotation_speed*delta)


func _on_life_span_timeout():
	queue_free()
