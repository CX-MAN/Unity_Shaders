Shader "Test/Shaders/PVD"
{
    Properties
    {
        _Diffuse ("Diffuse",Color) = (1,1,1,1)
    }
    SubShader
    {

        Tags { "LightMode"="ForwardBase" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
			fixed4 _Diffuse;
            struct a2v
            {
                float4 vertex : POSITION;
				fixed3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				fixed3 color:COLOR;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//将模型空间下法线转换为世界空间下的法线
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                //光照，因为只有一个平行光,平行光只有方向没有位置
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				//根据漫反射计算公式
				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldLight,worldNormal));
				o.color = ambient+diffuse;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color,1);
            }
            ENDCG
        }
    }
}
