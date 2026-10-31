shader_type canvas_item;

const float OUTLINE_WIDTH = 1.0; // number of pixels

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		// check if any pixel at a distance equal to OUTLINE_WIDTH is not transparent
		// note this can cause artifacts if texture has fully transparent inner pixels
		// (the shader assumes texture has no inner transparency)
		vec2 outline_distance = TEXTURE_PIXEL_SIZE * OUTLINE_WIDTH;
		float neighbor_alpha = 0.0;
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(outline_distance.x, 0.0)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(-outline_distance.x, 0.0)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(0.0, outline_distance.y)).a);
		neighbor_alpha = max(neighbor_alpha, texture(TEXTURE, UV + vec2(0.0, -outline_distance.y)).a);

		vec4 outline = vec4(outline_color.rgb, neighbor_alpha * outline_color.a);
		COLOR = mix(outline, COLOR, COLOR.a);
	}
}