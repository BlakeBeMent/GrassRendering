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
            Cull Off

            CGPROGRAM
            #pragma vertex VertexProgram 
            #pragma fragment FragmentProgram

            #include "UnityCG.cginc"

            uniform float _Width;
            uniform int _Density;
            uniform float _Rotation;
            StructuredBuffer<float2> _Positions;

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

            float3 RotateY(float3 vec, float radians)
            {
                float3x3 rotationMatrix =
                { cos(radians), 0, sin(radians),
                  0, 1, 0,
                  -sin(radians), 0, sin(radians)
                };

                return mul(rotationMatrix, vec);
            }

            v2f VertexProgram (VertexData i)
            {
                v2f o;
                unity_ObjectToWorld._m03_m23 = _Positions[i.instanceID];
                o.vertex = UnityObjectToClipPos(float4(RotateY(i.vertex, _Rotation), 1));
                o.uv = i.uv;
                return o;
            }

            float4 FragmentProgram(v2f i) : SV_Target
            {
                return float4(i.uv.x , i.uv.y, 0, 1);
            }
            ENDCG
        }
    }
}
