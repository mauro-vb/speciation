shader_type canvas_item;
render_mode unshaded;

uniform vec3 color: source_color;
uniform float num_cells: hint_range(2.0, 20.0, 1.0) = 10.0;
uniform float smoothness: hint_range(0.5, 2.0, 0.01) = 1.0;
uniform float angle: hint_range(0.0, 360.0) = 45.0;
uniform float progress: hint_range(0.0, 1.0) = 0.0; // Manual animation control

float rectanglef(vec2 uv, float width, float height, float feather) {
    vec2 uv_cartesian = uv * 2.0 - 1.0;
    vec2 uv_reflected = abs(uv_cartesian);
    float dfx = smoothstep(width, width + feather, uv_reflected.x);
    float dfy = smoothstep(height, height + feather, uv_reflected.y);
    return max(dfx, dfy);
}

vec2 rotation(vec2 uv, vec2 center, float ang) {
    mat2 rot = mat2(
        vec2(cos(ang), sin(ang)),
        vec2(-sin(ang), cos(ang))
    );
    uv -= center;
    uv = rot * uv;
    uv += center;
    return uv;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    vec2 igrid = floor(UV * num_cells) / num_cells;
    igrid = rotation(igrid, vec2(0.5), radians(angle));

    float offset = 2.0 - mod(progress * 4.0, 4.0);
    igrid.x += offset;

    vec2 fgrid = fract(UV * num_cells);
    float rect_mask = rectanglef(igrid, 0.001, 2.0, smoothness);
    float grid_mask = 1.0 - rectanglef(fgrid, rect_mask, rect_mask, 0.0);
    float outline_mask = 1.0 - rectanglef(fgrid, rect_mask + 0.1, rect_mask + 0.1, 0.0) - grid_mask;

    vec3 outline = outline_mask * color;
    vec3 output_color = mix(tex_color.rgb, outline, outline_mask);
    float output_alpha = tex_color.a * (outline_mask + grid_mask);

    COLOR = vec4(output_color, output_alpha);
}
