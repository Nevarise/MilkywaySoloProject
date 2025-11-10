extends Label

@onready var not_ready_yet: Label = $"."
@onready var pop_up_timer_1: Timer = $"pop up timer1"

func _ready():
	not_ready_yet.visible = false
	
func _on_start_pressed() -> void:
	not_ready_yet.visible = true
	pop_up_timer_1.start()
	
func _on_pop_up_timer_timeout(): 
	not_ready_yet.visible = false
