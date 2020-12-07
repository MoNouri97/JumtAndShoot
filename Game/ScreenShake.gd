extends Node2D
class_name CameraShake

var amplitude := 16.0

onready var shakeTween := $ShakeTween
onready var frequency := $Frequency
onready var camera:Camera2D = get_parent()

func _ready() -> void:
	start_shake()

func new_shake() -> void:
	var rand := Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	shakeTween.interpolate_property(
			camera,
			'offset',
			camera.offset,
			rand,
			frequency.wait_time,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
			)
	shakeTween.start()

func start_shake(
duration:float=0.2, strength:float=16, freq:float=20.0
) -> void:
	amplitude = strength
	frequency.wait_time = 1 / freq
	frequency.start()
	new_shake()
	yield(get_tree().create_timer(duration), "timeout")
	stop_shake()

func stop_shake():
	shakeTween.interpolate_property(
		camera,
		'offset',
		camera.offset,
		Vector2.ZERO,
		frequency.wait_time,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	shakeTween.start()
	frequency.stop()

func _on_Frequency_timeout() -> void:
	new_shake()
