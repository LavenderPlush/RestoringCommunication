shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform vec4 hatch_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float spacing       = 0.08;
uniform float thickness     = 0.02;
uniform float freq          = 18.0;
uniform float amp           = 0.008;
uniform float hatch_angle   = 45.0;
uniform float contrast      = 0.5;
uniform float smoothness    = 0.1;
uniform vec2  uv_scale      = vec2(1.0, 1.0);

vec2 hash22(vec2 p)
{
    float h1 = sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123;
    float h2 = sin(dot(p, vec2(269.5, 183.3))) * 43758.5453123;
    return fract(vec2(h1, h2));
}

vec2 noise2d(vec2 x)
{
    vec2 i = floor(x);
    vec2 f = fract(x);
    vec2 u = f*f*(3.0 - 2.0*f);
    vec2 a = hash22(i + vec2(0.0));
    vec2 b = hash22(i + vec2(1.0, 0.0));
    vec2 c = hash22(i + vec2(0.0, 1.0));
    vec2 d = hash22(i + vec2(1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec2 rotate(vec2 p, float angle)
{
    float c = cos(angle);
    float s = sin(angle);
    return vec2(c*p.x + s*p.y, -s*p.x + c*p.y);
}

float getHatchPattern(vec2 p, float angle)
{
    vec2 pr = rotate(p, angle);
    float idx    = floor(pr.y / spacing);
    float localY = pr.y - (idx + 0.5) * spacing;
    float j = (noise2d(vec2(pr.x * freq, idx)).x - 0.5) * amp;
    float dist = abs(localY + j) - thickness;
    float wAA = fwidth(dist);
    float stripeMask = smoothstep(0.0, wAA, -dist);
    return stripeMask;
}

void fragment()
{
    vec4 raw_screen = textureLod(screen_texture, SCREEN_UV, 0.0);
    float lum = dot(raw_screen.rgb, vec3(0.299, 0.587, 0.114));
    vec2 uv = UV / uv_scale;
    float hatch_exists = getHatchPattern(uv, radians(hatch_angle));
    float shadow_mask = 1.0 - smoothstep(contrast - smoothness, contrast + smoothness, lum);
    float final_line_strength = hatch_exists * shadow_mask;
    vec3 final_col = mix(raw_screen.rgb, hatch_color.rgb, final_line_strength);

    COLOR.rgb = final_col;
}