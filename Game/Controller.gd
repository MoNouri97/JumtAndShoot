extends Node2D
class_name Controller

var input:Dictionary = {
	"x":0,
	"jump":false,
	"attack":false,
	"target":Vector2.ZERO
}


func get_input() -> Dictionary:
	return input
