// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Test/SingleTex"
{
    Properties
    {
        _MainTex("Main Tex",2D) = "white"{}
        _Color("Color",Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss ("Gloss",Range(8,255)) = 20
    }
    
    SubShader
    {
    	//逐像素，顶点着色器仅需要把法线传给片元着色器即可
        Tags { "LightMode"="ForwardBase" }
		pass
		{
		CGPROGRAM
        #pragma vertex vert
		#pragma fragment frag 
		#include "Lighting.cginc"
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _Color;
		fixed3 _Specular;
		float _Gloss;
        struct a2v
        {
            fixed4 vertex :POSITION;
			fixed3 normal :NORMAL;
			fixed4 texCoord:TEXCOORD0;
        };
		struct v2f
		{
		    fixed4 pos :SV_POSITION;
			fixed3 worldNormal :TEXCOORD0;
			fixed4 worldPos:TEXCOORD1;
			float2 uv:TEXCOORD2;
		};
		v2f vert (a2v v)
		{
		   v2f o;
		   o.pos = UnityObjectToClipPos(v.vertex);
		   o.worldNormal = UnityObjectToWorldNormal(v.normal);
		   o.worldPos = mul(unity_ObjectToWorld,v.vertex);
		   //o.uv = v.texCoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
		   o.uv = TRANSFORM_TEX(v.texCoord,_MainTex);
		   return o;
		}
		fixed4 frag(v2f i): SV_Target
		{
		   fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			//通过内置函数获得的方向，没归一化
		   fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
		   fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
		   fixed3 diffuse = _LightColor0.rgb*albedo*(saturate(dot(lightDir,i.worldNormal)));
           fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz- i.worldPos);
           fixed3 h = normalize(lightDir+viewDir);
           fixed3 specular =_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(h,i.worldNormal)),_Gloss);
		   return fixed4(ambient+diffuse+specular,1);
		  // return fixed4(1,0,0,0);
		}
        ENDCG
	     }  
		
    }
	FallBack "Specular"
}
