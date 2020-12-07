extends CPUParticles2D

var done := false

func _ready() -> void:
	one_shot = true
	emitting = true
	for c in get_children():
		c = c as CPUParticles2D
		if not c :
			continue
		c.one_shot = true
		c.emitting = true
		c.lifetime = lifetime

func _process(_delta: float) -> void:
	if not emitting and not done:
		done = true
		yield(get_tree().create_timer(lifetime), "timeout")
		queue_free()


