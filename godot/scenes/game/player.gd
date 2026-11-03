extends CharacterBody2D

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
	ATTACK
}

const WALK_DURATIONS := {
	Direction.S: 0.2,
	Direction.SW: 0.4,
	Direction.W: 0.2,
	Direction.NW: 0.2,
	Direction.N: 0.2,
	Direction.NE: 0.4,
	Direction.E: 0.2,
	Direction.SE: 0.2,
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

@export var entrance_speech: AudioStream
@export var attack_swing: AudioStream

var path: PackedVector2Array
var target_position := position
var target_monster: Node2D
var _direction := Direction.SE:
	set(value):
		_direction = value
		_update_animation()
var _state := State.IDLE:
	set(value):
		_state = value
		_update_animation()
var _sprite_offset := Vector2(0, -16)

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite


func _ready() -> void:
	SfxController.play(entrance_speech)


func _process(_delta: float) -> void:
	if path and _state == State.IDLE:
		move()


func move() -> void:
	target_position = path[0]
	path.remove_at(0)
	
	if target_position == (position - _sprite_offset):
		return

	_direction = VECTOR_TO_DIRECTION[
		Vector2i((target_position - (position - _sprite_offset)).sign())
	]

	var tween = create_tween()
	tween.tween_property(
		self,
		^"position",
		target_position + _sprite_offset,
		WALK_DURATIONS[_direction],
	)
	_state = State.WALK

	await tween.finished
	if path:
		move()
	else:
		_state = State.IDLE


func attack(target: Node2D) -> void:
	if _state != State.IDLE:
		return
		
	target_monster = target
	_state = State.ATTACK
	SfxController.play(attack_swing)


func _update_animation() -> void:
	_animated_sprite.play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])


func _on_animated_sprite_animation_finished() -> void:
	if _state == State.ATTACK:
		target_monster.hit(0)
		_state = State.IDLE
