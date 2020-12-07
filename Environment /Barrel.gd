extends RigidBody2D

export var damage := 20
var Effect = preload("res://Particles/explosion.tscn")
var exploded := false
var flaming := false

func _ready() -> void:
	if randf() > 0.7:
		flaming = true
		$Flames.emitting = true
	else:
		$Flames.emitting = false

func take_damage(_val=0):
	if exploded:
		return
	exploded = true
	visible = false
	$DamageZone.monitoring = true
	hide()

	Global.spawn(Effect.instance(),global_position)
	AudioManager.playSfx("explode")
	Global.shake_camera(0.2,30,16)

	yield(get_tree().create_timer(0.2),"timeout")
	queue_free()

func _on_DamageZone_body_entered(body: Node) -> void:
	if body.has_method('take_damage'):
		body.call_deferred('take_damage',damage)


func _on_Barrel_body_entered(_body: Node) -> void:
	if flaming :
		take_damage()
