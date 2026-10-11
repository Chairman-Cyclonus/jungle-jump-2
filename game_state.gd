extends Node
const LEVEL_COUNT = 2
var current_level = 1
var score = 0
var level_start_score = 0
var menu_mode = "title"
var muted = false
var transitioning = false
var music: AudioStreamPlayer
var music_track = ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music = AudioStreamPlayer.new()
	music.volume_db = -20
	add_child(music)
	music.finished.connect(func(): music.play())

func start_game():
	if transitioning:
		return
	score = 0
	level_start_score = 0
	current_level = 1
	load_level()

func load_level():
	_transition_to("res://main.tscn")

func retry_level():
	if transitioning:
		return
	score = level_start_score
	load_level()

func next_level():
	if transitioning:
		return
	current_level += 1
	level_start_score = score
	if current_level > LEVEL_COUNT:
		show_menu("win")
	else:
		load_level()

func show_menu(mode = "title"):
	if transitioning:
		return
	menu_mode = mode
	_transition_to("res://ui/title.tscn")

func _transition_to(path):
	if transitioning:
		return
	transitioning = true
	get_tree().paused = true
	var layer = CanvasLayer.new()
	layer.layer = 100
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(layer)
	var fade = ColorRect.new()
	fade.color = Color(0.02, 0.07, 0.08, 0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(fade)
	var tween = layer.create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.22)
	await tween.finished
	var result = get_tree().change_scene_to_file(path)
	if result != OK:
		push_error("Could not load scene: " + path)
		layer.queue_free()
		get_tree().paused = false
		transitioning = false
		return
	await get_tree().scene_changed
	await get_tree().process_frame
	tween = layer.create_tween()
	tween.tween_property(fade, "color:a", 0.0, 0.22)
	await tween.finished
	layer.queue_free()
	get_tree().paused = false
	transitioning = false

func play_music(track):
	if DisplayServer.get_name() == "headless":
		return
	if music_track == track and music.playing:
		return
	music_track = track
	music.stream = load("res://assets/audio/%s.ogg" % track)
	music.play()

func sound(effect):
	if DisplayServer.get_name() == "headless":
		return
	var player = AudioStreamPlayer.new()
	player.stream = load("res://assets/audio/%s.ogg" % effect)
	player.volume_db = -13
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func toggle_mute():
	muted = not muted
	AudioServer.set_bus_mute(0, muted)

func _unhandled_key_input(event):
	if event.pressed and not event.echo and event.keycode == KEY_M:
		toggle_mute()

func _exit_tree():
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null

