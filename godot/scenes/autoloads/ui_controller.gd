extends Node

const HOVER_COOLDOWN := 0.05

@export var _ui_hover_sound: AudioStream
@export var _ui_pressed_sound: AudioStream

var hover_cooldown_elapsed := 0.0


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_entered_tree)


func _process(delta: float) -> void:
	hover_cooldown_elapsed += delta


func _on_node_entered_tree(node: Node) -> void:
	if node is Button:
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node.mouse_entered.connect(_on_node_hovered)
		node.focus_entered.connect(_on_node_focused)
		node.pressed.connect(_on_node_pressed)

	if node is Slider:
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node.mouse_entered.connect(_on_node_hovered)
		node.focus_entered.connect(_on_node_focused)
		node.drag_started.connect(_on_node_pressed)

	if node is TabBar:
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node.tab_hovered.connect(_on_node_hovered.unbind(1))
		node.tab_changed.connect(_on_node_pressed.unbind(1))


func _on_node_focused() -> void:
	# prevent sound playing when focus is automatic rather than user driven
	if (
		Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up")
		or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down")
	):
		_play_ui_sound(_ui_hover_sound)


func _on_node_hovered() -> void:
	# cooldown used to prevent unpleasant overlapping hover sounds
	if hover_cooldown_elapsed >= HOVER_COOLDOWN:
		_play_ui_sound(_ui_hover_sound)
		hover_cooldown_elapsed = 0.0


func _on_node_pressed() -> void:
	_play_ui_sound(_ui_pressed_sound)


func _play_ui_sound(audio_stream: AudioStream) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = audio_stream
	audio_stream_player.bus = &"SFX"
	add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
