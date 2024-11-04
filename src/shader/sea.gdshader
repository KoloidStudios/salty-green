shader_type canvas_item;

varying vec2 world_pos;
uniform vec3 water_color;
uniform sampler2D noise : repeat_enable;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(vec3(VERTEX, 0.0), 1.0)).xy;
}

void fragment() {
	vec2 _uv = world_pos * 0.005;
	_uv.x += sin(TIME + (_uv.x + _uv.y) * 25.0) * 0.01;
	_uv.y += cos(TIME + (_uv.x + _uv.y) * 25.0) * 0.01;
	NORMAL_MAP = texture(noise, _uv).rgb;
}