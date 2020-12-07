extends Node2D
class_name Gun

export var fire_rate = 1.0
export var kick_back = 0.0
export var bullets_per_shot = 1
onready var muzzle = $Sprite/Muzzle
var Bullet = preload("res://Guns/Bullet.tscn")
onready var shotCooldown = $ShotCooldown

var actor:Actor
var layer:int
var mask:int
var target_pos:Vector2


func _ready() -> void:
	shotCooldown.wait_time = (1 / fire_rate)
	actor = get_parent().get_parent() as Actor
	layer = actor.collision_layer
	mask = actor.collision_mask

func aim(target:Vector2)->void:
	target_pos = target
	look_at(target)
	if global_position.x > target.x:
		get_parent().scale.x = -1
#		rotation_degrees +=180
	else:
		get_parent().scale.x = 1

func shoot(color : Color) -> float:
	if shotCooldown.time_left != 0:
		return 0.0
	if actor == Global.player:
		AudioManager.playSfx('shoot')
	for i in range(bullets_per_shot):
		spawn_bullet(i,color)
	shotCooldown.start()
	return kick_back

func spawn_bullet(idx:int,color:Color)->void:
	var bullet = Bullet.instance() as Bullet
	bullet.color = color
	bullet.collision_mask = mask
	bullet.collision_layer = layer
	bullet.global_position = muzzle.global_position
	if actor == Global.player:
		bullet.shot_by_player = true
	rotation_degrees += randf() * 5 * idx
	get_tree().root.add_child(bullet)
	bullet.scale = scale
	bullet.linear_velocity = 1000 * get_global_transform().x
