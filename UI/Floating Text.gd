extends Node2D

export var text := '+' setget set_text

func set_text(val:String) -> void:
	text = val
	$Node2D/Label.text = val
func set_color(color:Color) -> void:
	modulate = color
