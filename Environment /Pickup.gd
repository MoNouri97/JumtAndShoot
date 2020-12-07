extends Area2D

func _on_Pickup_body_entered(body: Node) -> void:
	if body.has_method('reset_jumps'):
		body.call_deferred('reset_jumps')
		queue_free()
