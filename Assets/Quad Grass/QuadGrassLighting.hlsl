#if !defined(QUAD_GRASS_INCLUDED)
#define QUAD_GRASS_INCLUDED
#include "UnityCG.cginc"

float4 _Color;
float _Density;
float _MinHeight;
float _BaseWidth;
float _TipWidth;
float _WidthAttenuation;

struct VertexData {
	float4 vertex : POSITION;
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
	o.position = UnityObjectToClipPos(i.vertex);
	o.uv = i.uv;
	return o;
}

float4 FragmentProgram(v2f i) : SV_TARGET
{
	float seed = i.uv.x * _Density;
	float x = abs(frac(seed) * 2.0 - 1.0);

	float height = lerp(_MinHeight, 1, hash(floor(seed)));
	float width = lerp(_BaseWidth, _TipWidth, 1 - pow(1 - i.uv.y / height, _WidthAttenuation));

	if (i.uv.y > height || x > width) discard;

	return _Color * i.uv.y;
}
#endif
