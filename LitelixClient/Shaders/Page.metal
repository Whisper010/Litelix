//
//  Page.metal
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 26/04/24.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 pageFadeOut(float2 pos, half4 color, float posX, float2 s){
    
    if (posX <= 0) {
        if (pos.x >= s.x - abs(posX) && pos.x <= s.x ) {
            float progress = abs(posX) /s.x;
            
            return half4(0,0,0,0);
        }
        return color;
    } else {
        if (pos.x >= 0 && pos.x <= posX) {
            return half4(0,0,0,0);
        }
        
    }
    return color;
}
