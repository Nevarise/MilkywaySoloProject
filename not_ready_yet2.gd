extends Label

@onready var not_ready_yet: Label = $"."
@onready var pop_up_timer: Timer = $"pop up timer2"

func _ready():
	not_ready_yet.visible = false
	
func _on_options_pressed() -> void:
	not_ready_yet.visible = true
	pop_up_timer.start()
	
func _on_pop_up_timer_timeout() -> void:
	not_ready_yet.visible = false
