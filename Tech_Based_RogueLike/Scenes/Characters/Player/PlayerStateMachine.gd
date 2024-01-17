extends StateMachine


func _init():
	_add_state("idle")
	_add_state("move")

func _ready():
	set_state(states.idle)

func _state_logic(_delta):
	parent.get_input()
	parent.move()

func _get_transition():
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
	return -1

func _enter_state(_previous_state, _new_state):
	match _new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
