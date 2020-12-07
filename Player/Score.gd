extends Control

var score = Global.score
onready var label = $CenterContainer/Node2D/Label

func _ready() -> void:
	label.text = str(score)
# warning-ignore:return_value_discarded
	Global.connect("score_changed",self,"update_score")


func update_score(new:int)->void:
	label.text = str(new)
	$AnimationPlayer.play("Pulse")
