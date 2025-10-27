extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export_flags_2d_physics var layers_2d_physics

func _physics_process(_delta):
	pass
		
		#detect inpit
		#store variable
			#To move around
	var directionx = Input.get_axis("ui_left","ui_right")
	velocity.x = directionx * 200
						 
		#animation
	if directionx:
		animated_sprite_2d.play("walk")
		
		#flips sprite around when looking left and right
	var anim = $AnimatedSprite2D
	if 	Input.is_action_pressed("ui_left"): 
		anim.flip_h = true
	if 	Input.is_action_pressed("ui_right"): 
		anim.flip_h = false
			
	if not Input.is_anything_pressed():
		animated_sprite_2d.play("idle")
		
	move_and_slide()
