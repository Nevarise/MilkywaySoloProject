extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 

func _on_start_pressed() -> void:
	print("Nothing yet")

func _on_practice_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial_stage.tscn")
