extends Controller

func _ready() -> void:
	Global.player = get_parent()

func _exit_tree() -> void:
	Global.player = null

func get_input() -> Dictionary:
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	input = {
		"x":x,
		"jump":Input.is_action_just_pressed("jump"),
		"attack":Input.is_action_pressed("attack"),
		"target":get_global_mouse_position()
	}
	return input

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
