extends CharacterBody2D

const RUN_SPEED := 150.0
const JUMP_VELOCITY := -300.0
var gravity := ProjectSettings.get("physics/2d/default_gravity") as float

enum State { IDLE, WALK, JUMP, DIE } 
var current_state: State = State.IDLE
@onready var animated_sprite_2d: AnimatedSprite2D = $Node2D/AnimatedSprite2D
@onready var enemy_check: RayCast2D = $Node2D/EnemyCheck
@onready var enemy_check_2: RayCast2D = $Node2D/EnemyCheck2
@onready var die: AudioStreamPlayer = $Die



func _ready() -> void:
	add_to_group("player")



func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_input()
	update_state()
	apply_movement()
	update_animation()
	check_for_enemy_collision()


func check_for_enemy_collision() -> void:
	if enemy_check.is_colliding(): 
		var collider = enemy_check.get_collider()
		if collider.is_in_group("black"):  
			die.play()
			current_state = State.DIE 
			animated_sprite_2d.play("die")  
			queue_free() 
			get_tree().change_scene_to_file("res://UI/game_over.tscn")
	if enemy_check_2.is_colliding(): 
		var collider = enemy_check_2.get_collider()
		if collider.is_in_group("black"): 
			die.play()
			current_state = State.DIE 
			animated_sprite_2d.play("die")  
			queue_free() 
			get_tree().change_scene_to_file("res://UI/game_over.tscn")  
			return


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_input() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * RUN_SPEED

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY


func update_state() -> void:
	if not is_on_floor():
		current_state = State.JUMP
	elif is_zero_approx(velocity.x):
		current_state = State.IDLE
	else:
		current_state = State.WALK


func apply_movement() -> void:
	move_and_slide()


func update_animation() -> void:
	match current_state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.WALK:
			animated_sprite_2d.play("walk")
		State.JUMP:
			animated_sprite_2d.play("jump")
		State.DIE:
			animated_sprite_2d.play("die")


	if not is_zero_approx(velocity.x):
		animated_sprite_2d.flip_h = velocity.x < 0
