#if !defined(SHELL_TEXTURED_GRASS_INCLUDED)
#define SHELL_TEXTURED_GRASS_INCLUDED
#include "UnityCG.cginc"

int _ShellCount;
float _Density, _Scarcity;
float _Height;
float _MinHeight;
float _HeightAttenuation;
float3 _BaseColor, _TipColor;
float _BaseWidth, _TipWidth;

struct VertexData {
	float4 vertex : POSITION;
	float4 normal : NORMAL;
	float2 uv : TEXCOORD0;
	uint instanceID : SV_InstanceID;
};

struct v2f {
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD0;
	float shellHeight : TEXCOORD1;
	uint instanceID : SV_InstanceID;
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

	o.shellHeight = pow((float) i.instanceID / (_ShellCount - 1.0), _HeightAttenuation);
	i.vertex += i.normal * _Height * o.shellHeight;

	o.position = UnityObjectToClipPos(i.vertex);
	o.uv = i.uv;
	o.instanceID = i.instanceID;

	return o;
}

float4 FragmentProgram(v2f i) : SV_Target
{
	float2 block = floor(i.uv * _Density);

	// block uvs relative to the center of the block with range [-1,1]
	float2 blockCoords = frac(i.uv * _Density) * 2.0 - 1.0;

	int blockSeed = block.x + block.y * 100;
	float blockValue = hash(blockSeed);
	
	if (blockValue < _Scarcity)
		discard;

	// convert block values from [_Scarcity, 1] to [_MinHeight, 1]
	float blockHeight = (_MinHeight - _MinHeight * blockValue + blockValue - _Scarcity) / (1 - _Scarcity);

	float width = lerp(_BaseWidth, _TipWidth, i.shellHeight / blockHeight);

	if (i.shellHeight > blockHeight || length(blockCoords) > width)
		discard;

	float3 color = lerp(_BaseColor, _TipColor, i.shellHeight);
	return float4(color * i.shellHeight, 1);
}
#endif