extends Label

@onready var not_ready_yet2: Label = $"."
@onready var pop_up_timer: Timer = $"pop up timer"

func _ready():
	not_ready_yet2.visible = false
	
func _on_options_pressed() -> void:
	not_ready_yet2.visible = true
	pop_up_timer.start()
	
func _on_pop_up_timer_timeout(): 
	not_ready_yet2.visible = false
