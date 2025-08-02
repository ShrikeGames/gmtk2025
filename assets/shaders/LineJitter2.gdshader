shader_type canvas_item;

uniform bool shaking       = false;
uniform float amplitude    = 1.0;
uniform float noise_scale  = 20.0;
uniform float noise_speed  = 20.0;
/* Shift this value to create the dissolving effect. Represents the percentage
   of the image that's been dissolved. */
uniform float progress : hint_range(0.0, 1.0);
uniform vec2 texture_size;
// How far the pixels will float away before dissolving
uniform float float_dist = 6.0;
// Increase how far pixels can vertically differ from the "wave"
uniform float progress_rand_range = 0.2;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}
float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i + vec2(0.0,0.0));
  float b = hash(i + vec2(1.0,0.0));
  float c = hash(i + vec2(0.0,1.0));
  float d = hash(i + vec2(1.0,1.0));
  vec2 u = f*f*(3.0-2.0*f);
  return mix(a, b, u.x) +
  (c - a) * u.y * (1.0 - u.x) +
  (d - b) * u.x * u.y;
}

void fragment() {
  if (shaking) {
    vec2 uv = UV;
    vec4 orig = texture(TEXTURE, uv);
    if (orig.a <= 0.0) {
      discard;
    }

    // Generate two noise values to construct a random direction.
    float nx = noise(uv * noise_scale + vec2(TIME * noise_speed, 0.0));
    float ny = noise(uv * noise_scale + vec2(0.0, TIME * noise_speed));
    // Map [0,1] to [-1,1]
    vec2 rand_dir = normalize(vec2(nx * 2.0 - 1.0, ny * 2.0 - 1.0));

    // Use another noise value to determine the jitter amplitude sign.
    float n = noise(uv * noise_scale + vec2(TIME * noise_speed));
    float off = (n * 2.0 - 1.0) * amplitude;

    // Offset along a random direction
    vec2 uv2 = uv + rand_dir * off * TEXTURE_PIXEL_SIZE;
    COLOR = texture(TEXTURE, uv2);
	
  }else{
	// Float dist in terms of UV
	float v = float_dist / texture_size.y;
	/* "Adjusted" progress based on how far above/below the image that the float
	   dist extends, plus a bit of randomness for which pixel floats when */
	float p = progress * (1.0 + (v + progress_rand_range) * 2.0) - v -
	   progress_rand_range + random(UV) * progress_rand_range;
	/* Value ranging from 0 to 1 depending on how far UV.y is above p */
	float q = smoothstep(p - v * 2.0, p, UV.y);
	// Map another pixel's UV to this one based on q (shift by up to v pixels)
	float mapped_uv_y = UV.y + v - v * q * step(q, 1.0);
	
	COLOR = texture(TEXTURE, vec2(UV.x, mapped_uv_y));
	// Increase transparency as particles begin to float away
	COLOR.a -= 1.0 - q;
	}
	
}