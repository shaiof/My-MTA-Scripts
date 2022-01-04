float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0);
float sNorFac = 1;
float bumpSize = 1;
float envIntensity = 1;
float bumpIntensity = 0.25;
float sAdd = 0.1;
float sMul = 1.1;
float sCutoff = 0.16;
float sPower = 2;
texture sReflectionTexture;
texture sRandomTexture;
static const float pi = 3.141592653589793;
#define GENERATE_NORMALS
#include "mta-helper.fx"

sampler3D RandomSampler = sampler_state
{
	Texture = (sRandomTexture);
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Point;
};

sampler2D ReflectionSampler = sampler_state
{
	Texture = (sReflectionTexture);	
	AddressU = Mirror;
	AddressV = Mirror;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

struct VSInput
{
  float3 Position : POSITION0;
  float3 Normal : NORMAL0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
  float4 Position : POSITION0;
  float2 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
  float3 SparkleTex : TEXCOORD2;
  float3 Normal : TEXCOORD3;
  float4 WorldPos : TEXCOORD4;
};

PSInput VertexShaderFunction(VSInput VS)
{
	PSInput PS = (PSInput)0;
	MTAFixUpNormal( VS.Normal );
	PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 16 * bumpSize;
	PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 16 * bumpSize;
	PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 16 * bumpSize;
	PS.Normal = MTACalcWorldNormal( VS.Normal );
	PS.WorldPos.xyz = mul( float4(VS.Position.xyz,1) , gWorld ).xyz;
	PS.TexCoord = VS.TexCoord;
	float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );	
	float4 viewPos = mul( worldPos , gView );
	PS.WorldPos.w = viewPos.z / viewPos.w;
	PS.Position = mul( viewPos, gProjection);
	PS.Diffuse.r = MTACalcGTABuildingDiffuse(VS.Diffuse).a;
	PS.Diffuse.g = pow( mul( VS.Normal, (float3x3)gWorld ).z ,2.5 );
	float3 h = normalize(normalize(gCameraPosition - worldPos.xyz ) - normalize(gCameraDirection));
	PS.Diffuse.g *=  1 - saturate(pow(saturate(dot(PS.Normal,h)), 2));
	PS.Diffuse.g *=  saturate(1 + gCameraDirection.z);
	return PS;
}

float3 GetUV(float3 position, float4x4 ViewProjection)
{
	float4 pVP = mul(float4(position, 1.0f), ViewProjection);
	pVP.xy = float2(0.5f, 0.5f) + float2(0.5f, -0.5f) * ((pVP.xy / pVP.w) * uvMul) + uvMov;
	return float3(pVP.xy, pVP.z / pVP.w);
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;
	vFlakesNormal = 2 * vFlakesNormal - 1.0;
	float3 viewDir = normalize(PS.WorldPos.xyz - gCameraPosition);
	vFlakesNormal = bumpIntensity * vFlakesNormal;
	float3 worldNormal = normalize(refract(PS.Normal, vFlakesNormal, 1));
	float3 reflectDir = normalize(reflect(viewDir, worldNormal));
	float3 currentRay = PS.WorldPos.xyz + reflectDir * sNorFac;
	float farClip = gProjection[3][2] / (1 - gProjection[2][2]);
	currentRay += 2 * gWorld[2].xyz * (1.0 + (PS.WorldPos.w / farClip));
	float3 nuv = GetUV(currentRay , gViewProjection);
	float4 envMap = tex2D( ReflectionSampler, nuv.xy );
	float lum = (envMap.r + envMap.g + envMap.b)/3;
	float adj = saturate( lum - sCutoff );
	adj = adj / (1.01 - sCutoff);
	envMap += sAdd;
	envMap = (envMap * adj);
	envMap = pow(envMap, sPower);
	envMap *= sMul;
	envMap.rgb = saturate( envMap.rgb );
	float4 finalColor = float4(envMap.rgb, PS.Diffuse.g * envIntensity);
	finalColor.a *= PS.Diffuse.r;	
	return saturate(finalColor);
}

technique car_paint_reflite_layered
{
	pass P0
	{
		CullMode = 1;
		DepthBias = -0.0002;
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique fallback
{
	pass P0
	{
		
	}
}