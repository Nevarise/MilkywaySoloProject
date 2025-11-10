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


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $"Coyote Timer"

var target : Vector2
var launched = false
@export var rest_length = 50.0
@export var stiffness := 20.0
@export var damping := 2.0
@onready var player: CharacterBody2D = $"."
@onready var ray := $RayCast2D
@onready var rope := $Line2D

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
			elif Input.is_action_just_pressed("swing"):
				switch_state(STATE.SWING)
		
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
			elif Input.is_action_pressed("swing"):
				switch_state(STATE.SWING)
				
		STATE.JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)
			handle_movement()
			
			if Input.is_action_just_released("jump") or velocity.y >= 0:
				velocity.y = 0
				switch_state(STATE.FALL)
				
		STATE.SWING: 
			print("swing swing")
			ray.look_at(get_global_mouse_position()) 
			if Input.is_action_pressed("swing"):
				launch()
			if Input.is_action_just_released("swing"):
				retract()
				if is_on_floor():
					switch_state(STATE.FLOOR)
				else:
					switch_state(STATE.FALL)
			if launched:
				handle_grapple(delta)
		
func launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()

func retract():
	launched = false
	rope.hide()
	
func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	var displacement = target_dist - rest_length
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		var vel_dot = player.velocity.dot(target_dir)
		var damp = -damping * vel_dot * target_dir
		force = spring_force * damp
		
	player.velocity += force * delta
	update_rope()
	
func update_rope():
	rope.set_point_position(1, to_local(target))
	
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
