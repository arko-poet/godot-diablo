extends Node2D

signal hovered(hover_reference: Node2D)

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var outline_shader: ShaderMaterial = sprite.material


func hit(damge: int) -> void:
	_die()


func _on_area_2d_mouse_entered() -> void:
	outline_shader.set_shader_parameter(&"enabled", true)
	hovered.emit(self)


func _on_area_2d_mouse_exited() -> void:
	outline_shader.set_shader_parameter(&"enabled", false)
	hovered.emit(null)


func _die() -> void:
	sprite.play("DIE_SE")
	await sprite.animation_finished
	queue_free()
