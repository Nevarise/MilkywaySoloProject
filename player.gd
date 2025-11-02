extends CharacterBody2D

enum STATE {
	FALL,
	FLOOR,
	JUMP,
	LATCH,
	SWING,
	LAUNCH
}

const FALL_GRAVITY := 1500.0
const FALL_VELOCITY:= 500.0
const WALK_VELOCITY := 150.0
const JUMP_VELOCITY := -450.0
const JUMP_DECELERATION := 1500.0
const ACCELERATION := 0.1
const DECELERATION := 0.1
const SPRINT := 300.0

@onready var grapple := $Grappling
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $"Coyote Timer"

var active_state := STATE.FALL

func _ready() -> void:
	switch_state(active_state)

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
func switch_state(to_state: STATE) -> void:
	var previous_state := active_state
	active_state = to_state
	
	match active_state: 
		STATE.FALL:	
			animated_sprite_2d.play("fall")
			if previous_state == STATE.FLOOR:
				coyote_timer.start()
			
		STATE.JUMP:
			animated_sprite_2d.play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()


func process_state(delta: float) -> void:
	match active_state:
		STATE.FALL:
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			handle_movement()
			 
			if is_on_floor():
				switch_state(STATE.FLOOR)
			elif Input.is_action_just_pressed("jump") and coyote_timer.time_left > 0:
				switch_state(STATE.JUMP)
		
		STATE.FLOOR:
			if Input.get_axis("left", "right"):
				if Input.is_action_pressed("sprint"):
					animated_sprite_2d.play("run")
				else:
					animated_sprite_2d.play("walk")
			else:
				animated_sprite_2d.play("idle")
			handle_movement()
			
			if not is_on_floor():
				switch_state(STATE.FALL)
			elif Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP)
				
		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			handle_movement()
			
			if Input.is_action_just_released("jump") or velocity.y >= 0:
				velocity.y = 0
				switch_state(STATE.FALL)
			
		
			
func handle_movement() -> void: 
	var input_direction := signf(Input.get_axis("left","right"))
	var Speed = WALK_VELOCITY
	
	if Input.is_action_pressed("sprint"):
		Speed = SPRINT
		
	if input_direction:
		animated_sprite_2d.flip_h = input_direction < 0
		velocity.x = lerp(velocity.x, input_direction * Speed, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
