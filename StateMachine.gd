
class_name StateMachine
extends Node

enum State { IDLE, WALK, JUMP }

var current_state: State = State.IDLE
var prev_state: State = State.IDLE

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D


var state_handlers = {
	State.IDLE: "_handle_idle",
	State.WALK: "_handle_walk",
	State.JUMP: "_handle_jump"
}

func _ready():
	set_state(State.IDLE)


func set_state(new_state: State) -> void:
	if new_state != current_state:
		prev_state = current_state
		current_state = new_state
		call(state_handlers[current_state])


func _handle_idle() -> void:
	animator.play("idle")

func _handle_walk() -> void:
	animator.play("walk")

func _handle_jump() -> void:
	animator.play("jump")
