shader_type canvas_item;

void fragment() {
    vec2 uv = SCREEN_UV - vec2(0.50); // Center the effect
    float dist = length(uv) * 2.0;   // Distance from the center
    float intensity = 1.0 - smoothstep(0.3, 1.1, dist); // Control fade

    vec4 color = vec4(0.0, 0.0, 0.0, 1.0 - intensity); // Dark edges, bright center
    COLOR = color;
}
