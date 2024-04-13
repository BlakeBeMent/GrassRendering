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

            float _Width;
            int _Density;

            struct VertexData
            {
                float4 vertex : POSITION;
                uint instanceID : SV_InstanceID;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float CalculatePosition(int id)
            {
                return 2.0 * _Width * id / (_Density - 1.0) - _Width;
            }

            v2f VertexProgram (VertexData i)
            {
                v2f o;
                float xPos = CalculatePosition(i.instanceID);
                unity_ObjectToWorld._m03_m13_m23_m33 = float4(xPos, 0, 0, 1);
                unity_ObjectToWorld._m00 = 0.02;
                o.vertex = UnityObjectToClipPos(i.vertex);
                return o;
            }

            float4 FragmentProgram (v2f i) : SV_Target
            {
                return float4(0, 1, 0, 1);
            }
            ENDCG
        }
    }
}
