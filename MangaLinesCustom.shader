Shader "Custom/MangaLines" {
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LineColor ("Line Color", Color) = (1,1,1,1)
        _LineWidth ("Line Width", Range(0.001, 0.1)) = 0.01
    }

    SubShader 
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _LineColor;
            float _LineWidth;

            v2f vert (appdata v) 
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target 
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                float2 p = i.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                float line1 = step(abs(fract(p.x * 20) - 0.5), _LineWidth);
                float line2 = step(abs(fract(p.y * 20) - 0.5), _LineWidth);
                float line3 = step(abs(fract(p.x * 20 + p.y * 20) - 0.5), _LineWidth);
                float line4 = step(abs(fract(p.x * 20 - p.y * 20) - 0.5), _LineWidth);
                float lines = min(min(line1, line2), min(line3, line4));

                return lerp(color, _LineColor, lines);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}