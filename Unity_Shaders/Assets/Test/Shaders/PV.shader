// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Test/PV"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8,255)) = 20
    }

    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
		pass
		{
		CGPROGRAM
        #pragma vertex vert
		#pragma fragment frag 
		#include "Lighting.cginc"
		fixed4 _Diffuse;
		fixed4 _Specular;
		float _Gloss;
        struct a2v
        {
            fixed4 vertex :POSITION;
			fixed3 normal :NORMAL;
        };
		struct v2f
		{
		    fixed4 pos :SV_POSITION;
			fixed3 color :COLOR;
		};
		v2f vert (a2v v)
		{
		   v2f o;
		   o.pos = UnityObjectToClipPos(v.vertex);
		   fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
		   fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		   fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
		   fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(lightDir,worldNormal));

		   fixed3 reflectDir = normalize(reflect(-_WorldSpaceLightPos0.xyz,worldNormal));
		   fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex));
		   fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);
		   o.color = ambient+diffuse+specular;
		   return o;
		}
		fixed4 frag(v2f i): SV_Target
		{
		   return fixed4(i.color,1);
		}
        ENDCG
	     }  
		
    }
	FallBack "Diffuse"
}
