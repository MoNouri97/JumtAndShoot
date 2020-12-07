extends Control

export var max_health := 100.0

onready var filled = $Filled
onready var empty = $Empty
onready var tween = $Tween

onready var health = max_health

func _ready() -> void:
# warning-ignore:return_value_discarded
	Global.player.connect("health_changed",self,"on_health_change")

func on_health_change(new_health:float)->void:
	health = new_health
	tween.interpolate_property(
		filled,
		"margin_right",
		filled.margin_right,
		range_lerp(health,0,100,-1000,-20),
#		(.0 / max_health) * health,
		0.5,
		Tween.TRANS_BACK,Tween.EASE_IN_OUT
		)
	tween.start()
