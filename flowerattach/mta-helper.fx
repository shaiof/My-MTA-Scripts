//
// mta-helper.fx
//
// File version: 0.0.1
// Date updated: 2011-09-26
//
// Big file of doom containg most of the stuff you need to get shaders working with MTA
//
 
 
//
// This file has 4 sections:
//      1. Variables
//      2. Renders states (parital - includes only those that are used the most)
//      3. Helper functions
//      4. Normal generation
//
 
 
 
//####################################################################################################################
//####################################################################################################################
//
// Section #1 : Variables
//
//####################################################################################################################
//####################################################################################################################
 
//---------------------------------------------------------------------
// These parameters are set by MTA whenever a shader is drawn
//---------------------------------------------------------------------
 
//
// Matrices
//
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gWorldView : WORLDVIEW;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
float4x4 gViewInverseTranspose : VIEWINVERSETRANSPOSE;
 
//
// Camera
//
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraDirection : CAMERADIRECTION;
 
//
// Seconds counter
//
float gTime : TIME;
 
//
// Strongest light influence
//
float4 gLightAmbient : LIGHTAMBIENT;
float4 gLightDiffuse : LIGHTDIFFUSE;
float4 gLightSpecular : LIGHTSPECULAR;
float3 gLightDirection : LIGHTDIRECTION;
 
 
 
//####################################################################################################################
//####################################################################################################################
//
// Section #2 : Renders states
//
//####################################################################################################################
//####################################################################################################################
 
//---------------------------------------------------------------------
// The parameters below mirror the contents of the D3D registers.
// They are only relevant when using engineApplyShaderToWorldTexture.
//---------------------------------------------------------------------
 
//------------------------------------------------------------------------------------------
// renderState (partial) - String value should be one of D3DRENDERSTATETYPE without the D3DRS_  http://msdn.microsoft.com/en-us/library/bb172599%28v=vs.85%29.aspx
//------------------------------------------------------------------------------------------
 
int gLighting                      < string renderState="LIGHTING"; >;                        //  = 137,
 
float4 gGlobalAmbient              < string renderState="AMBIENT"; >;                    //  = 139,
 
int gDiffuseMaterialSource         < string renderState="DIFFUSEMATERIALSOURCE"; >;           //  = 145,
int gSpecularMaterialSource        < string renderState="SPECULARMATERIALSOURCE"; >;          //  = 146,
int gAmbientMaterialSource         < string renderState="AMBIENTMATERIALSOURCE"; >;           //  = 147,
int gEmissiveMaterialSource        < string renderState="EMISSIVEMATERIALSOURCE"; >;          //  = 148,
 
 
//------------------------------------------------------------------------------------------
// materialState - String value should be one of the members from D3DMATERIAL9  http://msdn.microsoft.com/en-us/library/bb172571%28v=VS.85%29.aspx
//------------------------------------------------------------------------------------------
 
float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;
 
 
//------------------------------------------------------------------------------------------
// textureState (partial) - String value should be a texture number followed by 'Texture'
//------------------------------------------------------------------------------------------
 
texture gTexture0           < string textureState="0,Texture"; >;
texture gTexture1           < string textureState="1,Texture"; >;
texture gTexture2           < string textureState="2,Texture"; >;
texture gTexture3           < string textureState="3,Texture"; >;
 
 
//------------------------------------------------------------------------------------------
// vertexDeclState  (partial)
//------------------------------------------------------------------------------------------
 
int gDeclNormal             < string vertexDeclState="Normal"; >;       // Set to 1 if vertex stream includes normals
 
 
 
//####################################################################################################################
//####################################################################################################################
//
// Section #3 : Helper functions
//
//####################################################################################################################
//####################################################################################################################
 
//------------------------------------------------------------------------------------------
// MTAUnlerp
// - Find a the relative position between 2 values
//------------------------------------------------------------------------------------------
float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}
 
 
//------------------------------------------------------------------------------------------
// MTACalcScreenPosition
// - Transform vertex position for the camera
//------------------------------------------------------------------------------------------
float4 MTACalcScreenPosition( float3 InPosition )
{
    float4 posWorld = mul(float4(InPosition,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    return mul(posWorldView, gProjection);
}
 
//------------------------------------------------------------------------------------------
// MTACalcWorldPosition
// - Transform position by current world matix
//------------------------------------------------------------------------------------------
float3 MTACalcWorldPosition( float3 InPosition )
{
    return mul(float4(InPosition,1), gWorld).xyz;
}
 
//------------------------------------------------------------------------------------------
// MTACalcWorldNormal
// - Rotate normal by current world matix
//------------------------------------------------------------------------------------------
float3 MTACalcWorldNormal( float3 InNormal )
{
    return mul(InNormal, (float3x3)gWorld);
}
 
//------------------------------------------------------------------------------------------
// MTACalcGTABuildingDiffuse
// - Calculate GTA lighting for buildings
//------------------------------------------------------------------------------------------
float4 MTACalcGTABuildingDiffuse( float4 InDiffuse )
{
    float4 OutDiffuse;
 
    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        OutDiffuse = InDiffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= diffuse.a;
    }
    return OutDiffuse;
}
 
//------------------------------------------------------------------------------------------
// MTACalcGTAVehicleDiffuse
// - Calculate GTA lighting for vehicles
//------------------------------------------------------------------------------------------
float4 MTACalcGTAVehicleDiffuse( float3 WorldNormal, float4 InDiffuse)
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
 
    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );
 
    // Add the strongest light
    float DirectionFactor = max(0.2, dot(WorldNormal, -gLightDirection ));
    float4 TotalDiffuse = (diffuse * DirectionFactor );
 
    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;
 
    return OutDiffuse;
}
 
float4 MTACalcGTAVehicleDiffuse2( float3 WorldNormal, float4 InDiffuse, float3 LightDirection )
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
 
    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );
 
    // Add the strongest light
    float3 lightDirection = LightDirection;
    float DirectionFactor = max(0.2, dot(WorldNormal, -lightDirection ));
    float4 TotalDiffuse = (diffuse * DirectionFactor );
 
    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;
 
    return OutDiffuse;
}
 
float4 MTACalcGTADynamicDiffuse( float3 WorldNormal, float4 InDiffuse, float3 LightDirection )
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
 
    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );
 
    // Add the strongest light
    float DirectionFactor = max(0,dot(WorldNormal, -LightDirection ));
    float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor );
 
    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;
 
    return OutDiffuse;
}
 
//------------------------------------------------------------------------------------------
// MTACalculateCameraDirection
// - Get camera direction to a world point
//------------------------------------------------------------------------------------------
float3 MTACalculateCameraDirection( float3 CamPos, float3 InWorldPos )
{
    return normalize( InWorldPos - CamPos );
}
 
//------------------------------------------------------------------------------------------
// CalcCameraDistance
// - Get camera distance from a world point
//------------------------------------------------------------------------------------------
float MTACalcCameraDistance( float3 CamPos, float3 InWorldPos )
{
    return distance( InWorldPos, CamPos );
}
 
//------------------------------------------------------------------------------------------
// CalculateSpecular
// - Get specular intensity
//------------------------------------------------------------------------------------------
float MTACalculateSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower )
{
    // Using Blinn half angle modification for performance over correctness
    LightDir = normalize(LightDir);
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-CamDir - LightDir);
    float r = dot(halfAngle, SurfNormal);
    return pow(saturate(r), SpecPower);
}
 
 
 
//####################################################################################################################
//####################################################################################################################
//
// Section #4 : Normal generation
//
//####################################################################################################################
//####################################################################################################################
 
//
// Declare '#define GENERATE_NORMALS' before this file is included to tell MTA to generate vertex normals if required
//
 
//---------------------------------------------------------------------
// Flags for MTA to do something about
//---------------------------------------------------------------------
int CUSTOMFLAGS
<
#ifdef GENERATE_NORMALS
    string createNormals = "yes";           // Some models do not have normals by default. Setting this to 'yes' will add them to the VertexShaderInput as NORMAL0
#endif
    string skipUnusedParameters = "yes";    // This will make the shader a bit faster
>;
 
 
//------------------------------------------------------------------------------------------
// MTAFixUpNormal
// - Make sure the normal is valid
//------------------------------------------------------------------------------------------
void MTAFixUpNormal( in out float3 OutNormal )
{
    // Incase we have no normal inputted
    if ( OutNormal.x == 0 && OutNormal.y == 0 && OutNormal.z == 0 )
        OutNormal = float3(0,0,1);   // Default to up
}
 
void MTAFixUpNormal2( in out float3 OutNormal )
{
    // Incase we have no normal inputted
    if (OutNormal.x == 0 && OutNormal.y == 0 && OutNormal.z == 0 ) {OutNormal = float3(0, 0, 1);}
       
    if (OutNormal.x >= 0.97) {OutNormal.x = 1;}
    if (OutNormal.x <= 0.03) {OutNormal.x = 0;}
    if (OutNormal.y >= 0.97) {OutNormal.y = 1;}
    if (OutNormal.y <= 0.03) {OutNormal.y = 0;}
    if (OutNormal.z >= 0.97) {OutNormal.z = 1;}
    if (OutNormal.z <= 0.03) {OutNormal.z = 0;}
}
 
//------------------------------------------------------------------------------------------
// MTACalcNormalMap
//------------------------------------------------------------------------------------------
// The Sobel filter extracts the first order derivates of the image,
// that is, the slope. The slope in X and Y directon allows us to
// given a heightmap evaluate the normal for each pixel. This is
// the same this as ATI's NormalMapGenerator application does,
// except this is in hardware.
//
// These are the filter kernels:
//
//  SobelX       SobelY
//  1  0 -1      1  2  1
//  2  0 -2      0  0  0
//  1  0 -1     -1 -2 -1
 
float3 MTACalcNormalMap(sampler Sampler, float2 texCoord, float4 lightness, float textureSize)
{
   float off = 1.0 / textureSize;
 
   // Take all neighbor samples
   float4 s00 = tex2D(Sampler, texCoord + float2(-off, -off));
   float4 s01 = tex2D(Sampler, texCoord + float2( 0,   -off));
   float4 s02 = tex2D(Sampler, texCoord + float2( off, -off));
 
   float4 s10 = tex2D(Sampler, texCoord + float2(-off,  0));
   float4 s12 = tex2D(Sampler, texCoord + float2( off,  0));
 
   float4 s20 = tex2D(Sampler, texCoord + float2(-off,  off));
   float4 s21 = tex2D(Sampler, texCoord + float2( 0,    off));
   float4 s22 = tex2D(Sampler, texCoord + float2( off,  off));
 
   // Slope in X direction
   float4 sobelX = s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
   // Slope in Y direction
   float4 sobelY = s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;
 
   // Weight the slope in all channels, we use grayscale as height
   float sx = dot(sobelX, lightness);
   float sy = dot(sobelY, lightness);
 
   // Compose the normal
   float3 normal = normalize(float3(sx, sy, 1));
 
   // Pack [-1, 1] into [0, 1]
   return float3(normal * 0.5 + 0.5);
}
 
//------------------------------------------------------------------------------------------