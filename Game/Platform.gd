extends RigidBody2D
var game = Global

export var speed := 1
export var size := 5.0

var enemy =preload("res://Player/Enemy.tscn").instance()
onready var sprite := $Sprite
onready var collisionShape := $CollisionShape2D

func _ready() -> void:
	sprite.scale.x *= size
	collisionShape.scale.x = size
	var chance := randf() > 0.2
	if chance:
		var pos = global_position + Vector2.UP * 10
		Global.spawn(enemy,pos)
		enemy.connect("ready",self,'set_props')

func set_props() -> void:
	enemy.controller.offensive = true
func _physics_process(delta: float) -> void:
	position += Vector2(0,speed * delta * 60)
