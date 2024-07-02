//
//  ImageEffects.metal
//  MusicTribes
//
//  Created by Federico Lagarmilla on 26/6/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]]
half4 glowGradient(
               float2 position,
               half4 color,
               float t) {
                   if (color.a < 0.01) {
                           return color;
                       }
                   float angle = atan2(position.y, position.x) + t;
                   return half4(
                                sin(angle),
                                sin(angle + 2),
                                sin(angle + 4),
                                color.a
                                );
}

[[ stitchable ]]
half4 glowFire(float2 position, half4 color, float t) {
    if (color.a < 0.01) {
        // Return the original color for transparent pixels
        return color;
    }
    // Define the custom colors
    constexpr half4 customOrange = half4(0.96, 0.38, 0.2, 1.0);
    constexpr half4 customGreen = half4(0.588, 0.58, 0.333, 1.0);
    constexpr half4 customCream = half4(0.96, 0.88, 0.81, 1.0);
    constexpr half4 white = half4(1.0, 1.0, 1.0, 1.0); // White

    // Define custom colors
    half4 color1 = customGreen; // White
    half4 color2 = customOrange; // Red

    float angle = atan2(position.y, position.x) + t;
    float factor = (sin(angle) + 1.0) / 2.0; // Normalize sin(angle) to range [0, 1]
    
    // Interpolate between color1 and color2
    half4 gradientColor = mix(color1, color2, factor);

    return half4(gradientColor.rgb, color.a); // Keep the original alpha
}

//  .colorEffect(ShaderLibrary.noise(.float(time)))
[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time) {
    float value = fract(sin(dot(position + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * currentColor.a;
}


[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float strength) {
    float min_strength = max(strength, 0.0001);
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return layer.sample(float2(coord_x, coord_y));
}

//   .distortionEffect(ShaderLibrary.wave(.float(start.timeIntervalSinceNow)), maxSampleOffset: .zero)
[[ stitchable ]] float2 wave(float2 position, float time) {
    return position + float2 (sin(time + position.y / 20), sin(time + position.x / 20)) * 2;
}

//    .layerEffect(ShaderLibrary.emboss(.float(0.5)), maxSampleOffset: .zero)
[[ stitchable ]] half4 emboss(float2 position, SwiftUI::Layer layer, float strength) {
    half4 current_color = layer.sample(position);
    half4 new_color = current_color;

    new_color += layer.sample(position + 1) * strength;
    new_color -= layer.sample(position - 1) * strength;

    return half4(new_color);
}

[[ stitchable ]] half4 gradientify(
    float2 position,
    half4 color,
    float4 box,
    float secs
) {
    // Normalised pixel coords from 0 to 1
    vector_float2 uv = position/box.zw;
    // Calculate color as a function of the position & time
    // Start from 0.5 to brighten the colors ( we don't want this to be dark )
    vector_float3 col = 0.5 + 0.5 *cos(secs+uv.xyx+float3(0, 2, 4));
    return half4(col.x, col.y, col.z, 1);
}
