int gCapsMaxAnisotropy < string deviceCaps="MaxAnisotropy"; >;
texture gTexture0 < string textureState="0,Texture"; >;
texture gTexture;

sampler Sampler0 = sampler_state
{
	Texture = (gTexture0);
};

sampler Sampler1 = sampler_state
{
	Texture = (gTexture);
	MipFilter = Linear;
	MaxAnisotropy = gCapsMaxAnisotropy;
	MinFilter = Anisotropic;
	AddressU = Mirror;
	AddressV = Mirror;
};

struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float2 TexCoord0 : TEXCOORD0;
  float2 TexCoord1 : TEXCOORD1;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float4 texel = tex2D(Sampler0, PS.TexCoord0);
	float4 light = tex2D(Sampler1, PS.TexCoord1);
	
	float4 finalColor = texel;
	finalColor *= saturate(light);
	
	finalColor.a *= PS.Diffuse.a;
	return finalColor;
}

technique lightmap
{
	pass P0
	{
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique fallback
{
	pass P0
	{
		
	}
}