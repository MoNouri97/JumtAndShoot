extends CPUParticles2D

export(Array,PackedScene) var enemies
var to_spawn:PackedScene = null
var enemy
func _ready() -> void:
	enemy = enemies[0].instance() as Actor
	modulate = enemy.color.main


func _on_Timer_timeout() -> void:
	if emitting :
		Global.spawn(enemy,global_position)
		emitting =false
	else:
		queue_free()
