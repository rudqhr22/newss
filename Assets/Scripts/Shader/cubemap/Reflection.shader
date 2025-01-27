﻿Shader "Custom/Reflection"
{
    Properties
    {   
        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
        _BumpMap("Normal", 2D) = "Bump"{}
        _MaskMap("Mask", 2D) = "white"{}        
        _Cube("CubeMap", Cube) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM     
        #pragma surface surf Lambert noambient
        #pragma target 3.0
        
        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MaskMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskMap;
            float2 uv_BumpMap;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);            
            float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            fixed4 m = tex2D(_MaskMap, IN.uv_MaskMap);

            o.Albedo = c.rgb * (1-m.r);
            o.Emission = re.rgb * m.r;
            o.Alpha = c.a;
        }
        /*
        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            //specular term
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SPPower);

            //final term
            float4 finalColor;
            finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
            finalColor.a = s.Alpha;//+ spec ;

            return finalColor;
        }
        */
        ENDCG
    }
    FallBack "Diffuse"
}
