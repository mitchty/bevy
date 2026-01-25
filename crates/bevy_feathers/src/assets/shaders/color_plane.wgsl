// This shader draws the color plane in various color spaces.
#import bevy_ui::ui_vertex_output::UiVertexOutput
#import bevy_ui_render::color_space::{
srgb_to_linear_rgb, hsl_to_linear_rgb,
}

struct ColorPlane {
  channel : f32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
            // WebGL2 structs must be 16 byte aligned.
            _webgl2_padding : vec3<f32>
#endif
}

@group(1) @binding(0) var<uniform> fixed : ColorPlane;

@fragment fn fragment(in : UiVertexOutput) -> @location(0) vec4<f32> {
  let uv = in.uv;
#ifdef PLANE_RG
  return vec4(srgb_to_linear_rgb(vec3(uv.x, uv.y, fixed.channel)), 1.0);
#else ifdef PLANE_RB
  return vec4(srgb_to_linear_rgb(vec3(uv.x, fixed.channel, uv.y)), 1.0);
#else ifdef PLANE_GB
  return vec4(srgb_to_linear_rgb(vec3(fixed.channel, uv.x, uv.y)), 1.0);
#else ifdef PLANE_HS
  return vec4(hsl_to_linear_rgb(vec3(uv.x, 1.0 - uv.y, fixed.channel)), 1.0);
#else ifdef PLANE_HL
  return vec4(hsl_to_linear_rgb(vec3(uv.x, fixed.channel, 1.0 - uv.y)), 1.0);
#else
  // Error color
  return vec4(1.0, 0.0, 1.0, 1.0);
#endif
}
