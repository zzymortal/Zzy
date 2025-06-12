extends CharacterBody2D

enum State { IDLE, WALK, RUN, DIE }

@export var max_speed: float = 100
@export var acceleration: float = 200
@export var direction := -1  
var gravity := ProjectSettings.get("physics/2d/default_gravity") as float
var current_state: State = State.WALK  

@onready var floor_check: RayCast2D = $Node2D/FloorCheck
@onready var wall_check: RayCast2D = $Node2D/WallCheck  
@onready var player_check: RayCast2D = $Node2D/PlayerCheck
@onready var animated_sprite_2d: AnimatedSprite2D = $Node2D/AnimatedSprite2D
@onready var death_timer: Timer = $DeathTimer 
@onready var die_timer: Timer = $DieTimer
@onready var wall_check_2: RayCast2D = $Node2D/WallCheck2  

func _ready() -> void:
	add_to_group("black")
	death_timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))
	die_timer.start() 

func _physics_process(delta: float) -> void:
	update_state()  
	handle_movement(delta)  
	handle_animation() 

# 更新状态和RayCast的方向
func update_state() -> void:
	wall_check.target_position.x = 10 * direction
	floor_check.target_position = Vector2(10 * direction, 20) 
	player_check.target_position.x = 10 * direction  


	if player_check.is_colliding():
		current_state = State.RUN
		return

	if current_state == State.RUN:
		if wall_check.is_colliding() or wall_check_2.is_colliding(): 
			current_state = State.DIE
			animated_sprite_2d.play("die")  
			death_timer.start(1.0) 
			return

	if wall_check.is_colliding() or not floor_check.is_colliding() or wall_check_2.is_colliding():
		direction *= -1 
		velocity.x = max_speed * 0.5 * direction 
		current_state = State.WALK 
		return

	if current_state != State.RUN:
		current_state = State.WALK


func handle_movement(delta: float) -> void:
	match current_state:
		State.IDLE:
			velocity.x = move_toward(velocity.x, 0, acceleration * delta)

		State.WALK:
			var walk_speed = max_speed * 0.5
			velocity.x = move_toward(velocity.x, walk_speed * direction, acceleration * delta)

		State.RUN:
			velocity.x = move_toward(velocity.x, max_speed * direction, acceleration * delta)

	velocity.y += gravity * delta

	move_and_slide() 


func handle_animation() -> void:
	match current_state:
		State.IDLE:
			animated_sprite_2d.play("idle")
		State.WALK:
			animated_sprite_2d.play("walk")
		State.RUN:
			animated_sprite_2d.play("run")
		State.DIE:
			animated_sprite_2d.play("die")


	if not is_zero_approx(velocity.x):
		animated_sprite_2d.flip_h = direction < 0


func _on_death_timer_timeout() -> void:
	queue_free() 
