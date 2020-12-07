extends Node2D
class_name Spawner
var game = Global

var EnemySpawner = preload("res://Particles/EnemySpawner.tscn")

export var disabled := false
export var ground_check := true
export var spawn_rate = 10.0
export var total = 10
export var x_range = [100,1800]
export var y_exact = 800
export var what_to_spawn:PackedScene
export var vars_to_set:Dictionary

onready var nextSpawn = $NextSpawn
var remaining_count
var spawn_pos := Vector2(1000,800)
var need_new_pos := true

func _ready() -> void:
	randomize()
	remaining_count = total
	spawn()
	nextSpawn.wait_time = 1 / spawn_rate
	nextSpawn.start()

func _physics_process(_delta: float) -> void:
	if not need_new_pos :
		return
	new_spawn_pos()

func new_spawn_pos() -> void :
#	raycast
	var new_pos = Vector2(rand_range(x_range[0],x_range[1]),y_exact)
	if ground_check :
		var space_state := get_world_2d().direct_space_state
		var result := space_state.intersect_ray(new_pos, new_pos + Vector2.DOWN * 5000)
	#	check for floor
		if not result :
			return
		var collider := result.collider as Node2D
		if collider.is_in_group('lava') :
			return
#	assign new pos
	spawn_pos = new_pos
	need_new_pos = false

func _on_EnemySpawn_timeout() -> void:
	if disabled :
		return
	spawn()

func spawn() -> void:
	if disabled :
		return
	if need_new_pos :
		new_spawn_pos()
	var instance_to_spawn = what_to_spawn.instance()
	game.spawn(instance_to_spawn,spawn_pos,self)
	need_new_pos = true

	for setting in vars_to_set:
		prints(setting,vars_to_set[setting])
		instance_to_spawn.set(setting,vars_to_set[setting])


	remaining_count -= 1
	if remaining_count == 0:
		nextSpawn.stop()


