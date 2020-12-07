extends Area2D


func _ready() -> void:
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method('take_damage'):
		body.call('take_damage',999)
	pass
