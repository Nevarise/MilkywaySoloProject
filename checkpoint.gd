extends Area2D


	
func _on_Checpoint_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.update_spawn(self.global_position)
