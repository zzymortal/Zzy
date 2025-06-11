# 文件名：Player.gd
extends CharacterBody2D

const RUN_SPEED := 150.0
const JUMP_VELOCITY := -300.0
var gravity := ProjectSettings.get("physics/2d/default_gravity") as float

@onready var state_machine: StateMachine = $StateMachine  # 引用 StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # 引用 AnimatedSprite2D

func _ready() -> void:
	state_machine.set_state(StateMachine.State.IDLE)  # 设置初始状态为 IDLE

func _physics_process(delta: float) -> void:
	handle_input()
	update_gravity(delta)
	state_machine.set_state(determine_state())  # 更新状态
	apply_movement()

	# 根据方向翻转角色
	if not is_zero_approx(velocity.x):
		animated_sprite_2d.flip_h = velocity.x < 0

func handle_input() -> void:
	# 处理输入
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * RUN_SPEED

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

func update_gravity(delta: float) -> void:
	# 更新重力
	if not is_on_floor():
		velocity.y += gravity * delta

func determine_state() -> StateMachine.State:
	# 根据物理状态判断当前状态
	if not is_on_floor():
		return StateMachine.State.JUMP
	elif is_zero_approx(velocity.x):
		return StateMachine.State.IDLE
	else:
		return StateMachine.State.WALK

func apply_movement() -> void:
	move_and_slide()
