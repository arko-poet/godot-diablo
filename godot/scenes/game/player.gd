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
}

@export var speech_entrance: AudioStream

const WALK_DURATIONS := {
	Direction.S: 0.45,
	Direction.SW: 0.8,
	Direction.W: 0.45,
	Direction.NW: 0.4,
	Direction.N: 0.45,
	Direction.NE: 0.8,
	Direction.E: 0.45,
	Direction.SE: 0.4,
}

var cell := Vector2i(-1, -0)
var _direction := Direction.SE:
	set(value):
		_direction = value
		print(Direction.keys()[_direction])
		_update_animation()
var _state := State.IDLE:
	set(value):
		_state = value
		_update_animation()
var _speed := 500
var _offset := Vector2(0, -32)

var path: PackedVector2Array
var grid: TileMapLayer

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite


func _ready() -> void:
	SfxController.play(speech_entrance)


func _process(_delta: float) -> void:
	if path and _state == State.IDLE:
		move()



func move() -> void:
	if not path:
		return
		
	var next_cell := grid.local_to_map(path[0])
	var target_position := path[0]
	path.remove_at(0)
	var direction := (next_cell - cell).sign()
	match direction:
		Vector2i(-1, -1):
			_direction = Direction.NW
		Vector2i(-1, 0):
			_direction = Direction.W
		Vector2i(-1, 1):
			_direction = Direction.SW
		Vector2i(0, -1):
			_direction = Direction.N
		Vector2i(0, 1):
			_direction = Direction.S
		Vector2i(1, -1):
			_direction = Direction.NE
		Vector2i(1, 0):
			_direction = Direction.E
		Vector2i(1, 1):
			_direction = Direction.SE
		_:
			_direction = _direction
	
	var tween = create_tween()
	tween.tween_property(self, ^"position", target_position + _offset, WALK_DURATIONS[_direction])
	_state = State.WALK
	cell = next_cell
	
	await tween.finished
	_state = State.IDLE


func _update_animation() -> void:
	_animated_sprite.play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])
