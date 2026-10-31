extends Node2D

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var outline_shader: ShaderMaterial = sprite.material



func _on_area_2d_mouse_entered() -> void:
	outline_shader.set_shader_parameter(&"enabled", true)


func _on_area_2d_mouse_exited() -> void:
		outline_shader.set_shader_parameter(&"enabled", false)
