extends Area2D

var packedscene = load('res://Scenes/tutorial_Stage2.tscn')

func _on_body_entered(_body) -> void:
	print("alice ay")
	get_tree().change_scene_to_packed(packedscene)
