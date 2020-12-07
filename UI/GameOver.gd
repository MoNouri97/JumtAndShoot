extends Control


func _ready() -> void:
# warning-ignore:return_value_discarded
	Global.player.connect("died",self,"_on_player_died")

func _on_player_died() -> void:
	$Highscore/New.visible = false
	$Highscore/Score.text = str(Global.score)
	$AnimationPlayer.play("fade")
	visible = true
	if Global.score == Global.high_score:
		$Highscore/AnimationPlayer.play("Pulse")


func _on_Retry_pressed() -> void:
	Global.score = 0
