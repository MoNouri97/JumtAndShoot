extends Control


#func _ready() -> void:
#	for btn in $Menu/CenterRow/Buttons.get_children():
#		btn.connect("pressed",self,'_on_btn_pressed',[btn.scene_to_load])

func _on_btn_pressed(scene_to_load) -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_to_load)


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	Global.performance_mode(button_pressed)
