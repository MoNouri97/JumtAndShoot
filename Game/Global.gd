extends Node

signal score_changed

export(Array,PackedScene) var Enemies
var shake = preload("res://Game/ScreenShake.tscn").instance()
var FloatingText = preload("res://UI/Floating Text.tscn")
var environment = preload("res://World_env.tres")

var player:Actor setget set_player
func set_player(actor:Actor)->void:
	player = actor
	if player:
# warning-ignore:return_value_discarded
		player.connect("died",self,'_on_player_died')
var camera:Camera2D
var high_score := 0
var score := 0 setget set_score
var speed := 1

func _ready() -> void:
	randomize()
	camera = get_tree().current_scene.find_node('Camera2D')
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta: float) -> void:
	if player and player.global_position.y < 400:
		speed = 2
	else:
		speed = 1
func set_score(val:int)->void:
	if not player and val > 0:
		return
	score = val
	emit_signal("score_changed",val)

func change_health(change:float)->void:
	if player:
		player.current_health += change


func spawn(
	node:Node2D,pos:Vector2,parent:Node=null
) -> void:
	node.global_position = pos
	if parent!=null:
		parent.add_child(node)
		node.owner = parent
	else:
		get_tree().root.call_deferred('add_child',node)

func shake_camera(duration:float=0.2, strength:float=16, freq:float=20.0) -> void:
	if not camera :
		camera = get_tree().current_scene.find_node('Camera2D')

	if not camera:
		return

	var cam_shake = camera.get_child(0) as CameraShake
	cam_shake.start_shake(duration,strength,freq)

func floating_text(text:String,pos:Vector2,color:Color=Color.tomato)->void:
	var f_text = FloatingText.instance()
	f_text.set_text(text)
	f_text.set_color(color)
	spawn(f_text,pos)

func performance_mode(toggle:bool):
	 $WorldEnvironment.environment = null if toggle else environment

func _on_player_died() -> void:
	if score > high_score:
		high_score = score
