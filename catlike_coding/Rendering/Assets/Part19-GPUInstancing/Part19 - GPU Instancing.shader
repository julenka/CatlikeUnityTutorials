﻿Shader "Custom/Part19 - GPU Instancing"
{

    Properties{
        _Tint("Tint", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}
        [NoScaleOffset] _NormalMap("Normals", 2D) = "bump" {}
        _BumpScale ("Bump Scale", Float) = 1


        [NoScaleOffset] _MetallicMap("Metallic", 2D) = "white" {}
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5

        _DetailTex("Detail Albedo", 2D) = "gray" {}
        [NoScaleOffset] _DetailNormalMap("Detail Normals", 2D) = "bump" {}
        _DetailBumpScale("Detail Bump Scale", Float) = 1
        
        [NoScaleOffset] _EmissionMap("Emission", 2D) = "black" {}
        _Emission("Emission", Color) = (0, 0, 0)
    }

    CustomEditor "Part19MyLightingShaderGUI"

    CGINCLUDE

    #define BINORMAL_PER_FRAGMENT

    ENDCG

    SubShader{
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma target 3.0 

            #pragma multi_compile _ VERTEXLIGHT_ON
            #pragma multi_compile _ SHADOWS_SCREEN
            #pragma shader_feature _METALLIC_MAP
            #pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
            #pragma shader_feature _EMISSION_MAP

            #define FORWARD_BASE_PASS

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #pragma multi_compile_instancing
            #include "My Lighting.cginc"
            ENDCG
        }
        Pass{
            Tags{
            "LightMode" = "ForwardAdd"
            }

            Blend One One
            ZWrite Off
            CGPROGRAM

            #pragma target 3.0

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #pragma multi_compile_fwdadd_fullshadows
            #pragma shader_feature _METALLIC_MAP
            #pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
            #include "My Lighting.cginc"

            ENDCG
        }

        Pass{
            Tags{
            "LightMode" = "ShadowCaster"
            }

            CGPROGRAM

            #pragma target 3.0
            
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #pragma vertex MyShadowVertexProgram
            #pragma fragment MyShadowFragmentProgram

            #include "My Shadows.cginc"

            ENDCG
        }
    }

}
