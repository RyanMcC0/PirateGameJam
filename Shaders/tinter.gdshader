shader_type canvas_item;

uniform float tint_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 color: source_color = vec4(1.0,1.0,1.0,1.0);
uniform float fade: hint_range(0.0,1.0) = 1.0;

void fragment() {
	vec4 main_texture = texture(TEXTURE, UV);
	vec4 final_output = main_texture;
	
	float original_modulation = 1.0 - tint_amount;
	
	final_output.rgb = mix(main_texture.rgb * original_modulation, color.rgb * tint_amount, tint_amount);
	final_output.a *= fade;
	
	COLOR = final_output;
}