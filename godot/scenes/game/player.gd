extends Node2D

enum Direction {
	S, SW, W, NW, N, NE, E, SE
}

enum State {
	IDLE
}

var _direction := Direction.S:
	set(value):
		_direction = value
		print(Direction.keys()[_direction])
		_update_animation()
var _state := State.IDLE:
	set(value):
		_state = value
		_update_animation()
var _cell := Vector2(-1, -1)

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite



func move(cell: Vector2i) -> void:
	print(cell)
	if cell.x < _cell.x and cell.y < _cell.y:
		_direction = Direction.NW
	elif cell.x == _cell.x and cell.y < _cell.y:
		_direction = Direction.N
	elif cell.x > _cell.x and cell.y < _cell.y:
		_direction = Direction.NE
	elif cell.x < _cell.x and cell.y == _cell.y:
		_direction = Direction.W
	elif cell.x > _cell.x and cell.y == _cell.y:
		_direction = Direction.E
	elif cell.x < _cell.x and cell.y > _cell.y:
		_direction = Direction.SW
	elif cell.x > _cell.x and cell.y > _cell.y:
		_direction = Direction.SE
	elif cell.x == _cell.x and cell.y > _cell.y:
		_direction = Direction.S


func _update_animation() -> void:
	_animated_sprite.play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])
