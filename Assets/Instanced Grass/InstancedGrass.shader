Shader "Unlit/InstancedGrass"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex VertexProgram 
            #pragma fragment FragmentProgram

            #include "UnityCG.cginc"

            uniform float _Width;
            uniform int _Density;
            StructuredBuffer<float> _Positions;

            struct VertexData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                uint instanceID : SV_InstanceID;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float CalculatePosition(int id)
            {
                return _Width * id / (_Density - 1.0) - _Width * 0.5;
            }

            v2f VertexProgram (VertexData i)
            {
                v2f o;
                unity_ObjectToWorld._m03 = _Positions[i.instanceID];
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.uv = i.uv;
                return o;
            }

            float4 FragmentProgram (v2f i) : SV_Target
            {
                return float4(0, i.uv.y, 0, 1);
            }
            ENDCG
        }
    }
}
