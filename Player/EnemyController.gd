extends Controller

var game = Global

export var offensive = true

func get_input() -> Dictionary:
	var target = game.player
	if not target:
		return input

	input.target = input.target.linear_interpolate(target.global_position ,0.1)
	input.attack = true





	if offensive:
		var dir = (target.global_position - global_position)
		if dir.length() > 500:
			input.x = dir.normalized().x
		elif dir.length() < 100:
			input.x = -dir.normalized().x

	return input
