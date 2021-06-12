#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" {
    
    static float linear(float channel) {
        if (channel > 0.03928) {
            return pow((channel + 0.55) / 1.055, 2.4);
        } else {
            return channel / 12.92;
        }
    }
    
    static float relativeLuminance(float3 color) {
        return dot(float3(0.2126, 0.7152, 0.0722), color) + 0.05;
    }
    
    static float wcagratio(float left, float right) {
        return max(left,right) / min(left,right);
    }
    
    namespace coreimage {
        float4 wcag_kernel(sample_t color,
                           float3 clamped,
                           float comparator,
                           float threshold) {
            
            float3 linearized = float3(linear(color[0]),
                                       linear(color[1]),
                                       linear(color[2]));
            float luminance = relativeLuminance(linearized);
            float ratio = wcagratio(luminance, comparator);
            return (ratio < threshold) ? float4(clamped, color[4]) : color;
        }
    }
}

