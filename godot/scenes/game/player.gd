extends Node2D

enum Direction {
	S, SW, W, NW, N, NE, E, SE
}

enum State {
	IDLE
}

var _direction := Direction.SE:
	set(value):
		_direction = value
		print(Direction.keys()[_direction])
		_update_animation()
var _state := State.IDLE:
	set(value):
		_state = value
		_update_animation()
var _cell := Vector2i(-1, -0)

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite



func move(cell: Vector2i) -> void:
	print("to %s" % cell)
	print("from %s" % _cell)
	var direction := (cell - _cell).sign()
	print("result %s" % direction)
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


func _update_animation() -> void:
	_animated_sprite.play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])
