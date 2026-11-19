class_name Monster
extends Character

signal hovered(monster: Node2D)

var outline_shader: ShaderMaterial

func _ready() -> void:
	super._ready()
	outline_shader = animated_sprite.material


func _on_mouse_entered() -> void:
	outline_shader.set_shader_parameter(&"enabled", true)
	hovered.emit(self)


func _on_mouse_exited() -> void:
	outline_shader.set_shader_parameter(&"enabled", false)
	hovered.emit(null)
