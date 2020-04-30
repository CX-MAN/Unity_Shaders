Shader "TinyGames/Model/Light-CastShadow-exp"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SpecularColor("SpecularColor",Color )=(1,1,1,1)
        _SpecularGloss("Gloss",Range(8.0,256)) = 20
		_SpeExp("Spe Strength", Range(0,3)) = 1
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		// 三个轴向的灯光
		_LightX("Light Direction X", Vector) = (1, 0, 0, 0)
		_LightColorX("Light Color X", Color) = (1, 1, 1, 1)
		_ExpX("Color Strength X", Range(0,3)) = 1
		_LightY("Light Direction Y", Vector) = (0, 1, 0, 0)
		_LightColorY("Light Color Y", Color) = (1, 1, 1, 1)
		_ExpY("Color Strength Y", Range(0,3)) = 1
		_LightZ("Light Direction Z", Vector) = (0, 0, 1, 0)
		_LightColorZ("Light Color Z", Color) = (1, 1, 1, 1)
		_ExpZ("Color Strength Z", Range(0,3)) = 1

		_EnvLight("Env Light Direction", Vector) = (1,0,0,0)
		_EnvColor("Env Color", Color) = (0,0,0,0)

		_Speed("Speed", Float) = 1
		_BoomColor("Boom Color", Color) = (1,1,1,1)
		_Start("Start", Float) = 0
	//	_HoldTime("HoldTime", Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc" 
            #include "AutoLight.cginc"
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldNormal :TEXCOORD1;
                float3 worldPos :TEXCOORD2;
            //    SHADOW_COORDS(3)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _SpecularColor;
            float  _SpecularGloss;
			float _SpeExp;
            float4  _Diffuse;

			fixed4 _LightX;
			fixed4 _LightColorX;
			float _ExpX;
			fixed4 _LightY;
			fixed4 _LightColorY;
			float _ExpY;
			fixed4 _LightZ;
			fixed4 _LightColorZ;
			float _ExpZ;

			fixed4 _EnvLight;
		    fixed4 _EnvColor;

			float _Speed;
			fixed4 _BoomColor;
			float _Start;
		//	float _HoldTime;

            v2f vert (a2v v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos  = mul(unity_ObjectToWorld,v.vertex).xyz;
            //    TRANSFER_SHADOW(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // 1.ambientColor
            //    float3  ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // 2.diffuseColor
                float3 N =  normalize(i.worldNormal);
                float3 L = normalize(_EnvLight.xyz);
                float3 diffuseColor =  _Diffuse.rgb * max(0.0,dot(N,L));

                // 3.specularColor
                float3  V = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                // H替代了Phong中的reflectDic = normalize(reflect(-L,N));
                float3 H = normalize(L+V);
                // 这里需要注意的是计算高光反射的时候使用的是【半角向量 H】和法向量的点积
                float3 specularColor =  _SpecularColor.rgb * pow(max(0,dot(H,N)),_SpecularGloss) * _SpeExp;

				// 添加三盏模拟灯的颜色
				fixed3 tempcolor;
				float3 lightcolor;
				tempcolor = saturate(dot(N, normalize(_LightX).xyz)) * _LightColorX.xyz * _ExpX;
				lightcolor = tempcolor;
				tempcolor = saturate(dot(N, normalize(_LightY).xyz)) * _LightColorY.xyz * _ExpY;
				lightcolor = lightcolor + tempcolor - lightcolor * tempcolor;
				tempcolor = saturate(dot(N, normalize(_LightZ).xyz)) * _LightColorZ.xyz * _ExpZ;
				lightcolor = lightcolor + tempcolor - lightcolor * tempcolor;

				// boom color
				float4 boom = _BoomColor;

				if (_Start > 0)
				{
					boom = _BoomColor * _Speed;
				}
				//if ((_Time.y - _StartTime) > _HoldTime)
				//	boom = _BoomColor;
				//else
				//	//boom = abs((_StartTime + _HoldTime/2) - _Time.y)/ (_HoldTime/2) * _BoomColor;
				//	boom = 1 - fixed4(_Time.yyy /1, 1);


                fixed4 col =  tex2D(_MainTex,i.uv) * float4 ((diffuseColor + specularColor + lightcolor) * boom  ,1);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Specular"
}
