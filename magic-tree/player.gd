extends CharacterBody2D

enum STATE {
	FALL,
	FLOOR,
	JUMP,
	DOUBLEJUMP
}

const FALL_GRAVITY := 1500.0
const FALL_VELOCITY:= 500.0
const WALK_VELOCITY := 200.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var active_state := STATE.FALL

func _ready() -> void:
	switch_state(active_state)

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
func switch_state(to_state: STATE) -> void:
	active_state = to_state
	
	match active_state: 
		STATE.FALL:	
			animated_sprite_2d.play("fall")

func process_state(_delta: float) -> void:
	match active_state:
		STATE.FALL:
			pass
func handle_movement() -> void: 
	var input_direction := signf(Input.get_axis("move_left","move_right"))
