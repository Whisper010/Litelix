//
//  leafThrough.metal
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 28/04/24.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] float2 wave(float2 pos, float t, float2 s) {
    float2 distance = /*pos / s*/  1 ;
    pos.y += sin(t*5 + pos.y/10) * distance.x * 10 ;
    return pos;
    
    
}

