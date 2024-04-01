Shader "Unlit/Quad Grass"
{
    Properties
    {
        _Color("Color", Color) = (0, 1, 0, 1)
        _Density("Density", Range(1, 500)) = 1
        _MinHeight("Min Height", Range(0, 1)) = 0
        _BaseWidth("Base Width", Range(0, 1)) = 1
        _TipWidth("Tip Width", Range(0, 1)) = 0
        _WidthAttenuation("Width Attenuation", Range(0, 4)) = 0
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            #include "QuadGrassLighting.hlsl"

            ENDHLSL
        }
    }
}
