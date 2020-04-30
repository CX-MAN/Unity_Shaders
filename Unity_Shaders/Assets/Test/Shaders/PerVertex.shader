// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Test/PerVertex"
 {
    Properties
	{
	  _Diffsue("Diffsue",Color) = (1,1,1,1)
	}
	SubShader 
	{
	   Pass
	   {	   
		Tags { "LightMode"="ForwardBase" }
		CGPROGRAM		
		#pragma vertex vert
		#pragma fragment frag
		#include"Lighting.cginc"
		float4 _Diffsue;
		struct a2v 
		{
		  float4 pos:POSITION;
		  float3 normal:NORMAL;
		};

	   struct v2f
	   {
		  float4 pos : SV_POSITION;
		  fixed3 color : COLOR;
	    };
		v2f vert(a2v v)
		{
		   v2f o;
		   //转换顶点坐标
		   o.pos = UnityObjectToClipPos(v.pos);
		   //环境光部分
		   float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
		   //在世界坐标中，计算光照
		   float3 worldNormal =normalize(mul(v.normal,(float3x3)unity_WorldToObject));
		   float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
		   o.color = ambient+_LightColor0.rgb* _Diffsue.rgb*saturate(dot(worldNormal,worldLight));
		   return o;
		}
	   float4 frag(v2f v):SV_TARGET0
		{
		    return float4(v.color,1);
		}
		ENDCG
		}
	}
	FallBack "Diffuse"
}
