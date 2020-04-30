Shader"Test/NormalMapWordSpace"
{
	Properties
	{
		_MainTex("Main Tex",2D )="white"{}
		_Color("Color Tint",Color) = (1,1,1,1)
		_BumpMap("Bump",2D) = "bump"{}
		_BumpScale("Bump Scale",Float) = 1.0
		_Specular("Specular",Color )=(1,1,1,1)
		_Gross("Gross",Range(8,256))= 8
	}
	SubShader 
	{
		
		Pass
		 {
		 	Tags{"LightMode" = "ForwardBase"}
		 	CGPROGRAM
		 	#pragma vertex vert
		 	#pragma fragment  frag 
		 	#include "Lighting.cginc"
		 	sampler2D  _MainTex;
		 	float4 _MainTex_ST;
		 	float4 _Color;
		 	sampler2D _BumpMap;
		 	float4 _BumpMap_ST;
		 	float _BumpScale;
		 	float4 _Specular;
		 	float _Gross;

		 	//定义输入输出数据结构
		 	struct a2v
		 	{
		 		float4 vertex :POSITION;//w分量标记是否是背面
		 		float3 normal:NORMAL;
		 		float4 tangent:TANGENT;
		 		float4 texcoord :TEXCOORD0; 
		 	};

		 	struct v2f
		 	{
		 		fixed4 pos : SV_POSITION;
		 		fixed4 uv: TEXCOORD0;
		 		fixed3 lightDir:TEXCOORD1;
		 		fixed3 viewDir:TEXCOORD2;
		 	};
		 	v2f vert(a2v v)
		 	{
		 		v2f o;
		 		o.pos = UnityObjectToClipPos(v.vertex);
		 		o.uv.xy = v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
		 		o.uv.zw = v.texcoord.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;
		 		o.lightDir = _WorldSpaceLightPos0;


		 		return o;
		 	}
		 	fixed4 frag(v2f i):SV_Target
		 	{
		 		
		 		return fixed4(1,1,1,1);
		 	}
		 	ENDCG

		}
	}
}