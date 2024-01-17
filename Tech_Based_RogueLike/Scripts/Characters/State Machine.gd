extends Node
class_name StateMachine

var states: Dictionary = {}
var previous_state: int = -1
var state: int = -1: set = set_state

@onready var parent: Character = get_parent()
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")

func _physics_process(delta):
	if state != -1:
		_state_logic(delta)
		var transition: int = _get_transition()
		if transition != 1:
			set_state(transition)

func _state_logic(_delta):
	pass

func _get_transition():
	return -1

func _add_state(new_state):
	states[new_state] = states.size()

func set_state(new_state):
	_exit_state(state)
	previous_state = state
	state = new_state
	_enter_state(previous_state, state)

func _enter_state(_previous_state, _new_state):
	pass

func _exit_state(_state_exited):
	pass
