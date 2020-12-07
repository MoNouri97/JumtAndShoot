tool
extends Node2D

export var refresh:= false setget set_refresh

func set_refresh(_v) -> void:
	add_sounds_to_tree()

export(Array,AudioStream) var sounds:Array = [] setget set_sounds

func set_sounds(val:Array) -> void:
	if val == sounds:
		return
	sounds = val


func add_sounds_to_tree():
	if not Engine.editor_hint:
		return
	for item in sounds:
		if (node_exists(make_name(item.resource_path))) :
			continue

		var audio_player =create_audio_player_from(item)
		add_child(audio_player)
		audio_player.owner = self

func node_exists(item : String) -> bool:
	return find_node(item) != null

func create_audio_player_from (sfx:AudioStream) -> AudioStreamPlayer:
	var audio_player:AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = sfx
	audio_player.name = make_name(sfx.resource_path)
	return audio_player

func make_name (file:String) -> String:
	var file_name := file.get_file()
	var clean_file_name := file_name.trim_suffix("."+file.get_extension())
	return clean_file_name

func playSfx(sound:String, pitch:=1.0) -> void :
	for node in get_children():
		node = node as AudioStreamPlayer
		if(node.name != sound):
			continue
		if node.is_playing():
			node.stop()
		node.play(0)
		node.pitch_scale = pitch


		break
