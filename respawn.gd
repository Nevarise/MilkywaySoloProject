extends Area2D

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		print("Respawn bro")
		get_tree().reload_current_scene()
