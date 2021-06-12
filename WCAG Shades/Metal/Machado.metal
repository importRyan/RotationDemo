#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" {
    
    namespace coreimage {
        float4 monochromat_kernel(sample_t color) {
            float3 simulated = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
            return float4(simulated, color.a);
        }
    }
    
    namespace coreimage {
        float4 tritan_kernel(sample_t color) {
            float3x3 simulation (float3(1.255528, -0.078411, 0.004733), float3(-0.076749, 0.930809, 0.691367), float3(-0.178779, 0.147602, 0.303900));
            float3 simulated = simulation * color.rgb;
            return float4(simulated, color.a);
        }
    }
    
    namespace coreimage {
        float4 deutan_kernel(sample_t color) {
            float3x3 simulation (float3(0.367322, 0.280085, -0.011820), float3(0.860646, 0.672501, 0.042940), float3(-0.227968, 0.047413, 0.968881));
            float3 simulated = simulation * color.rgb;
            return float4(simulated, color.a);
        }
    }
    
    namespace coreimage {
        float4 protan_kernel(sample_t color) {
            float3x3 simulation (float3(0.152286, 0.114503, -0.003882), float3(1.052583, 0.786281, -0.048116), float3(-0.204868, 0.099216, 1.051998));
            float3 simulated = simulation * color.rgb;
            return float4(simulated, color.a);
        }
    }
}
