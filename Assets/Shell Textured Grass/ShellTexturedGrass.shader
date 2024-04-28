Shader "Custom/ShellTexturing"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
			#include "./ShellTexturedGrassLighting.hlsl"
            ENDHLSL
        }
   }
}
