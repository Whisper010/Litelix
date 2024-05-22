//
//  leaf.metal
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 28/04/24.
//

#include <metal_stdlib>
#include <SWiftUI/SwiftUI_Metal.h>
using namespace metal;

[[stitchable]] float2 leaf(float2 pos, float dragX, float2 s ) {
    
    float progress = dragX/s.x; // Normalized value
    
    float pi = 3.14159f;
    
//    float angle = sin(progress * pi / 2.0f) * pi;
    float angle = progress * pi;
    
    
    float yFactor = pos.y / s.y;
    
    if (progress > 0) {

        float lift = sin(pos.y / s.y * pi);
        pos.y += lift * sin(angle);
        pos.x -= 3.0 * yFactor * (1.0f - cos(angle)) *(s.x - pos.x);
    }
    else if (progress < 0) {
        float lift = sin((s.y -pos.y)/ s.y * pi);
        pos.y += lift * sin(-angle);
        pos.x += 3.0 *  yFactor * (1.0f - cos(-angle)) * pos.x;
        
    }
    
    
    return pos;
}
