extends KinematicBody2D
class_name Actor

signal health_changed
signal died

const UP := Vector2(0,-1)
const FPS := 60

onready var controller := $Controller as Controller
onready var input:= controller.get_input()
onready var sprite = $Sprite

export var Gun:PackedScene
export(Dictionary) var color = {
	'main' :Color.white,
	'bullet' : Color.tomato
	}
export var health := 100.0

export var gravity := 2
export var speed := 10
export var acceleration := 100
export var jump_force := 30
export var max_mid_air_jumps := 1
export var weight = 50.0
const Particle = preload("res://Player/DeathParticles.tscn")

var velocity := Vector2.ZERO
var mid_air_jumps := 0
# used for squash and stretch
var hit_the_ground = false
var previous_motion = Vector2.ZERO
var equipped_gun = null
onready var current_health = health setget set_current_health
func set_current_health(val:float)->void:
	current_health = min(max(val,0),health)
	if current_health <= 0:
		die()
	Global.shake_camera()
	emit_signal("health_changed",current_health)

func _ready() -> void:
	assert(controller)
	sprite.modulate = color.main
	equip_gun()

func _physics_process(delta: float) -> void:
	input = controller.get_input()

	var on_floor := is_on_floor()
	if on_floor:
		reset_jumps()
	if input.jump:
		jump(on_floor)
	if input.attack:
		shoot()


	velocity.y += gravity * FPS

	move(input.x,delta)
	velocity.y = clamp(velocity.y,-jump_force*FPS,jump_force*FPS)
	velocity = move_and_slide(velocity,UP,false,4,PI/4,false)
	animate(delta,on_floor)
	check_collisions()

func _process(_delta: float) -> void:
	if global_position.y > 2000:
		take_damage(health)
	if equipped_gun:
		equipped_gun.aim(input.target)

func reset_jumps() -> void:
	mid_air_jumps = 0
	sprite.modulate = color.main

func equip_gun() -> void :
	equipped_gun = Gun.instance()
	$GunPos.add_child(equipped_gun)
	equipped_gun.owner = $GunPos

func move(value:float, delta:float) -> void:
	previous_motion = velocity
	velocity.x = move_toward(velocity.x , value * speed *FPS ,delta * FPS * acceleration)

func shoot() -> void:
	assert(equipped_gun)
	var kick = equipped_gun.shoot(color.bullet)
	var kick_vector = global_position.direction_to(input.target) * -1 * kick
	if not is_on_floor():
		kick_vector *= 2
	velocity += kick_vector * FPS

func jump(on_floor : bool) -> void:
	var can_jump := on_floor or mid_air_jumps < max_mid_air_jumps
	if not can_jump:
		return

	if not on_floor:
		mid_air_jumps += 1

	if mid_air_jumps == max_mid_air_jumps:
		sprite.modulate.r = 0.5
		sprite.modulate.g = 0.5
		Global.score -= 300
		Global.floating_text("-300",global_position)

	AudioManager.playSfx('jump')
	velocity.y = -jump_force * FPS

func animate(delta,on_floor) -> void :
#	""" Animation (sprite.scale = 0.7 , 0.7)"""
#	resetting the scale
	sprite.scale.x = lerp(sprite.scale.x,0.7,delta*10)
	sprite.scale.y = lerp(sprite.scale.y,0.7,delta*10)

	var jump = jump_force * FPS
	if not on_floor:
		hit_the_ground = false
		sprite.scale.y = range_lerp(abs(velocity.y),0,jump,0.5,1)
		sprite.scale.x = range_lerp(abs(velocity.y),0,jump,1,0.5)

	if not hit_the_ground and on_floor:
		hit_the_ground = true
		sprite.scale.x = range_lerp(abs(previous_motion.y),0,jump,0.5,1)
		sprite.scale.y = range_lerp(abs(previous_motion.y),0,jump,1,0.5)

func check_collisions () -> void:
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if check_for_lava(collision.collider):
			self.current_health = 0
			return
		if check_for_rigidbody(collision.collider):
			var collider := collision.collider as RigidBody2D
			collider.apply_impulse(global_position-collider.global_position, collision.normal * -weight)

func check_for_lava(collider : Node2D) -> bool:
	return collider.is_in_group('lava')

func check_for_rigidbody(collider : RigidBody2D) -> bool:
#	if the collider cannot be cast to rigidbody2D
	if not collider :
		return false
	return true

func die() -> void:
	emit_signal("died")
	AudioManager.playSfx("explodeSmall")
	var effect = Particle.instance()
	get_tree().root.add_child(effect)
	effect.position = global_position
	effect.modulate = color.main
	queue_free()

func take_damage(damage:float)->void:
	Global.shake_camera(0.4,32,30)
	AudioManager.playSfx('hit')
	self.current_health -= damage
