extends Area2D



func _on_body_entered(body) -> void:
	print("Respawn bro")
	get_tree().reload_current_scene()
