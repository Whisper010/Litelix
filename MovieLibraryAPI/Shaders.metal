//
//  Shaders.metal
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 19/03/24.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 rainbow(float2 pos, half4 color, float t, float maxY) {
    float angle = atan2(pos.y, pos.x) + t;
    
    float ratioBottom =  abs(pos.y)/maxY;
    float distanceToBottom = 1.0 - ratioBottom;
    float intensity = pow(distanceToBottom, 2);
    
    half3 customColor = half3(sin(angle), sin(angle+2), sin(angle+4));
    
    return half4(customColor * intensity, color.a);
}
