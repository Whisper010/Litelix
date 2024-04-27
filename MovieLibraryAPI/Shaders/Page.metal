//
//  Page.metal
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 26/04/24.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 pageFadeOut(float2 pos, half4 color, float posX, float maxX){
    
    if (posX <= 0) {
        if (pos.x >= maxX - abs(posX) && pos.x <= maxX ) {
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
