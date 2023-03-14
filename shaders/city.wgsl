struct UBO {
  coneBackScale: f32,
  viewportRatio: f32,
  lookDistance: f32,
  forward: vec3<f32>,
  // direction up overhead, better unit vector
  upward: vec3<f32>,
  rightward: vec3<f32>,
  cameraPosition: vec3<f32>,
};

@group(0) @binding(0)
var<uniform> uniforms: UBO;

const ALL_HEIGHT: f32 = 2000.0;

{{perspective}}

{{simplex}}

// main

struct VertexOut {
    @builtin(position) position : vec4<f32>,
    @location(1) h: f32,
};

@vertex
fn vertex_main(
    @location(0) position: vec2<f32>,
    @location(1) normal_idx: f32,
    @location(2) idx: f32,
) -> VertexOut
{
  var output: VertexOut;
  let h1 = simplexNoise2(vec2<f32>(position.x, position.y) * 0.0002) * ALL_HEIGHT * 0.6;
  let h2 = simplexNoise2(vec2<f32>(position.x, position.y) * 0.002) * ALL_HEIGHT * 0.25;
  let h3 = simplexNoise2(vec2<f32>(position.x, position.y) * 0.008) * ALL_HEIGHT * 0.05;
  let h4 = simplexNoise2(vec2<f32>(position.x, position.y) * 0.01) * ALL_HEIGHT * 0.05;
  let h5 = simplexNoise2(vec2<f32>(position.x, position.y) * 0.02) * ALL_HEIGHT * 0.05;
  let h = abs(h1 + h2 + h3 + h4 + h5) + 20.0;
  var p1 = vec3<f32>(position.x, 0.0, position.y);
  let d = 70.0;
  let up = h;
  // let up = 100.0;
  if (idx < 0.5) {
    p1 += vec3<f32>(-d, 0.0, -d);
  } else if (idx < 1.5) {
    p1 += vec3<f32>(d, 0.0, -d);
  } else if (idx < 2.5) {
    p1 += vec3<f32>(d, 0.0, d);
  } else if (idx < 3.5) {
    p1 += vec3<f32>(-d, 0.0, d);
  } else if (idx < 4.5) {
    p1 += vec3<f32>(-d, up, -d);
  } else if (idx < 5.5) {
    p1 += vec3<f32>(d, up, -d);
  } else if (idx < 6.5) {
    p1 += vec3<f32>(d, up, d);
  } else if (idx < 7.5) {
    p1 += vec3<f32>(-d, up, d);
  } else {
    p1 += vec3<f32>(13.0, 200.0, 13.0);
  }

  let p = transform_perspective(p1.xyz).pointPosition;
  let scale: f32 = 0.002;
  output.position = vec4(p[0]*scale, p[1]*scale, p[2]*scale, 1.0);
  // output.position = position;
  output.h = normal_idx;
  // output.h = 0.0;
  return output;
}

@fragment
fn fragment_main(fragData: VertexOut) -> @location(0) vec4<f32>
{
    // return fragData.color;
    // return vec4<f32>(0.0, 0.0, 1.0, 1.0);
    let h = fragData.h;

    if (h < 0.5) {
      return vec4<f32>(0.82, 0.82, 0.82, 1.0);
    } else if (h < 1.5) {
      return vec4<f32>(0.88, 0.88, 0.88, 1.0);
    } else if (h < 2.5) {
      return vec4<f32>(0.8, 0.8, 0.8, 1.0);
    } else if (h < 3.5) {
      return vec4<f32>(0.75, 0.75, 0.75, 1.0);
    } else if (h < 4.5) {
      return vec4<f32>(0.8, 0.8, 0.8, 1.0);
    } else {
      return vec4<f32>(1.0, 1.0, 1.0, 1.0);
    }

    // let a = 0.7 - (h / ALL_HEIGHT * 0.4 + 0.4);
    // return vec4<f32>(1.0, 1.0, 1.0, 1.0);
    // return vec4<f32>(a, a, a, 1.0);
}