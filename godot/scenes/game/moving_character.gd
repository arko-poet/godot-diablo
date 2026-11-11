extends AnimatedSprite2D

enum Direction {
	S,
	SW,
	W,
	NW,
	N,
	NE,
	E,
	SE,
}

enum State {
	IDLE,
	WALK,
	ATTACK,
}

const VECTOR_TO_DIRECTION := {
	Vector2i(-1, -1): Direction.W,
	Vector2i(-1, 0): Direction.SW,
	Vector2i(-1, 1): Direction.S,
	Vector2i(0, -1): Direction.NW,
	Vector2i(0, 1): Direction.SE,
	Vector2i(1, -1): Direction.N,
	Vector2i(1, 0): Direction.NE,
	Vector2i(1, 1): Direction.E,
}

@export var walk_durations: Dictionary[Direction, float]
@export var attack_animation_hit_frame: int

var path: PackedVector2Array
var target_position := position
var target_character: Node2D
var parent: Node2D
var _direction := Direction.SE:
	set(value):
		_direction = value
		_update_animation()
var _state := State.IDLE:
	set(value):
		_state = value
		_update_animation()


func _ready() -> void:
	var local_parent = get_parent()
	assert(local_parent, "Missing Parent Node")
	assert(local_parent is Node2D, "Parent is not Node2D")
	parent = local_parent


func _process(_delta: float) -> void:
	if path and _state == State.IDLE:
		move()


func move() -> void:
	target_position = path[0]
	path.remove_at(0)

	if target_position == position:
		return

	_direction = VECTOR_TO_DIRECTION[Vector2i((target_position - (position)).sign())]

	var tween = create_tween()
	tween.tween_property(self, ^"position", target_position, walk_durations[_direction])
	_state = State.WALK

	await tween.finished
	if path:
		move()
	else:
		_state = State.IDLE


func attack(target: Node2D) -> void:
	if _state != State.IDLE:
		return

	_direction = VECTOR_TO_DIRECTION[
		Vector2i((Vector2i(target.position - Vector2(0, 16)) - Vector2i(position)).sign())
	]

	target_character = target
	_state = State.ATTACK


func _update_animation() -> void:
	play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])


func _on_animated_sprite_animation_finished() -> void:
	if _state == State.ATTACK:
		_state = State.IDLE


func _on_animated_sprite_frame_changed() -> void:
	if (
		_state == State.ATTACK and target_character
		and frame == attack_animation_hit_frame
	):
		target_character.hit(0)
