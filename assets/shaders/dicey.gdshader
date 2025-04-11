shader_type canvas_item;

uniform float fade_line : hint_range(0.0, 1.0) = 0.0; // 0 parte arriba 1 parte baja
uniform float fade_width : hint_range(0.0, 1.0) = 0.0; // Ancho del gradiente

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
		float alpha_factor = smoothstep(fade_line, fade_line + fade_width, UV.y);
	    COLOR.a *= alpha_factor;


}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
