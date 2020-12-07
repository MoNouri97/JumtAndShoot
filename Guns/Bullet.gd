extends RigidBody2D
class_name Bullet

var game = Global

export var damage := 10
export(Color) var color = Color('fef74c') setget set_color
func set_color(val:Color)->void:
	color = val
	modulate = val
	$Trail.default_color = Color(val.r,val.g,val.b,0.3)

const Particle = preload("res://Particles/Sparks.tscn")
onready var collision = $CollisionShape2D
var shot_by_player = false

func _on_Bullet_body_entered(body: Node2D) -> void:

	var effect = Particle.instance()
	effect.position = global_position
	effect.rotation = rotation
	effect.modulate = color
	game.spawn(effect,global_position,null)
	queue_free()

	if not body.has_method('take_damage'):
		return
	body.take_damage(damage)
	if shot_by_player and body.is_in_group('Enemy'):
		game.score += 100
		game.floating_text("+100",global_position,color)
	if shot_by_player and body.is_in_group('Barrels'):
		game.change_health(50)
		game.floating_text("+HP",global_position,color)

func _on_Lifetime_timeout() -> void:
	queue_free()
