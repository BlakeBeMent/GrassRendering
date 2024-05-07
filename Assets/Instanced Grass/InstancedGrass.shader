Shader "Unlit/InstancedGrass"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            Cull Off

            HLSLPROGRAM
            #pragma vertex VertexProgram 
            #pragma fragment FragmentProgram

            #include "./InstancedGrassLighting.hlsl"
            ENDHLSL
        }
    }
}
