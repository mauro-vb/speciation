shader_type canvas_item;
render_mode unshaded;

uniform vec3 color: source_color = vec3(0.0, 0.0, 0.0); // Base replacement color
uniform vec3 background_color: source_color = vec3(1.0, 1.0, 1.0); // Replacement color for white pixels
uniform float threshold: hint_range(0.0, 1.0) = 0.1; // Replacement threshold

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    // Sample the screen texture using SCREEN_UV coordinates.
    vec4 tex_color = texture(screen_texture, SCREEN_UV);

    // Check if the pixel is white (all channels nearly at 1.0).
    bool isWhite = (tex_color.r > 0.98) && (tex_color.g > 0.98) && (tex_color.b > 0.98);

    // Calculate the brightness of the pixel.
    float brightness = length(tex_color.rgb);

    // Create a mask based on brightness: pixels below the threshold get replaced more.
    float mask = 1.0 - smoothstep(0.0, threshold, brightness);

    // Determine if the pixel is greyish:
    // Using a tight difference between channels (0.01) and excluding near-white pixels.
    bool isGrey = (abs(tex_color.r - tex_color.g) < 0.01) &&
                  (abs(tex_color.r - tex_color.b) < 0.01) &&
                  (tex_color.r < 0.98);

    // Default target color is the full base replacement color.
    vec3 targetColor = color;

    // For grey pixels, compute a lightening factor based on brightness.
    // - When brightness is 0 (black), lightFactor is 0 (full base color).
    // - As brightness increases (up to threshold), the factor increases,
    //   mixing in up to 50% white with the base color.
    if (isGrey) {
        float lightFactor = clamp(brightness / threshold, 0.0, 1.0);
        targetColor = mix(color, vec3(1.0), lightFactor * 0.5);
    }

    // Blend the original pixel with the chosen target color based on the mask.
    vec3 final_color = mix(tex_color.rgb, targetColor, mask);

	if (isWhite) {
        COLOR = vec4(background_color, tex_color.a);
    }
	else
	{
		COLOR = vec4(final_color, tex_color.a);
	}

}





