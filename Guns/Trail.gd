extends Line2D

func _ready() -> void:
	set_as_toplevel(true)


func _physics_process(_delta: float) -> void:
	add_point(get_parent().global_position)
	if points.size() > 5:
		remove_point(0)
