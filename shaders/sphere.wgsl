

#import lagopus::perspective

#import lagopus::rand

#import lagopus::colors

struct Params {
  // custom
  color: vec3f,
}

@group(0) @binding(1) var<uniform> params: Params;

// main

struct VertexOut {
  @builtin(position) position: vec4f,
  @location(0) idx: f32,
  @location(1) color: vec3f,
};

// const PI = 3.14159265358979323846264338327950288;

@vertex
fn vertex_main(
  @location(0) position: vec3f,
  @location(1) idx: u32,
) -> VertexOut {
  var output: VertexOut;

  let p = transform_perspective(position.xyz).point_position;
  let scale: f32 = 0.002;
  output.position = vec4(p[0] * scale, p[1] * scale, p[2] * scale, 1.0);
  output.idx = f32(idx);
  output.color = params.color;
  return output;
}

@fragment
fn fragment_main(vtx_out: VertexOut) -> @location(0) vec4f {
  let a = rand(vtx_out.idx);
  let color = hsl(vtx_out.color.x, vtx_out.color.y, vtx_out.color.z + a * 0.04);
  return vec4(color.xyz, 1.0);
}
