extends Button

export var scene_to_load:String=""


func _on_MenuButton_pressed() -> void:

	if(scene_to_load==""):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_to_load)
