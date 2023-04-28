Shader "Custom/MangaLines" 
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Speed ("Speed", Range(0.0, 10.0)) = 1.0
    }

    SubShader 
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        fixed4 _Color;
        float _Speed;

        struct Input 
        {
            float2 uv_MainTex;
            float3 worldPos;
            float3 worldNormal;
            float3 worldTangent;
            float3 worldBinormal;
        };

        void surf (Input IN, inout SurfaceOutput o) 
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float4 worldPos = mul(unity_ObjectToWorld, float4(IN.worldPos, 1.0));
            float3 worldVelocity = UnityObjectToClipPos(UnityGetVelocity(worldPos.xyz));
            float3 offset = worldVelocity * _Speed;

            IN.worldPos += offset;
            IN.worldPos = mul(unity_WorldToObject, float4(IN.worldPos, 1.0)).xyz;

            o.Normal = UnityObjectToWorldNormal(IN.worldNormal);
            o.Albedo *= c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
