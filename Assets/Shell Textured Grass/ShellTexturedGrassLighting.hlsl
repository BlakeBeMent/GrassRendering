#if !defined(SHELL_TEXTURED_GRASS_INCLUDED)
#define SHELL_TEXTURED_GRASS_INCLUDED
#include "UnityCG.cginc"

int _ShellCount;
int _Index;
float _Density;
float _Height;
float _MinHeight;
float3 _Color;

struct VertexData {
	float4 vertex : POSITION;
	float4 normal : NORMAL;
	float2 uv : TEXCOORD0;
};

struct v2f {
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD0;
};

float hash(uint n)
{
	// integer hash copied from Hugo Elias
	n = (n << 13U) ^ n;
	n = n * (n * n * 15731U + 789221U) + 1376312589U;
	return float(n & uint(0x7fffffffU)) / float(0x7fffffff);
}

v2f VertexProgram(VertexData i)
{
	v2f o;
	if (_ShellCount > 1)
	{
		float height = _Height * _Index / (_ShellCount - 1);
		i.vertex += i.normal * height;
	}
	o.position = UnityObjectToClipPos(i.vertex);
	o.uv = i.uv;
	return o;
}

float4 FragmentProgram(v2f i) : SV_Target
{
	float2 block = floor(i.uv * _Density);
	int seed = block.x + block.y * 100;
	float rand = lerp(_MinHeight, 1, hash(seed));
	if (_ShellCount > 1 && (float) _Index / (_ShellCount - 1) > rand)
		discard;
	return float4(_Color.x, _Color.y * (float) _Index / _ShellCount, _Color.z, 1);
}
#endif