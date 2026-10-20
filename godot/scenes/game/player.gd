extends CharacterBody2D

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
var cell := Vector2i(-1, -0)
var _speed := 500

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite

#
#func _process(_delta: float) -> void:
	#if position == target_position:
		#return
		#
	#velocity = (target_position - position).normalized() * _speed
	#move_and_slide()
		#
	#
	


func move(path: PackedVector2Array, grid: TileMapLayer) -> void:
	print(path)
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
	tween.tween_property(self, ^"position", target_position, 0.5)
	await tween.finished
	cell = next_cell
	move(path, grid)



func _update_animation() -> void:
	_animated_sprite.play("%s_%s" % [State.keys()[_state], Direction.keys()[_direction]])
