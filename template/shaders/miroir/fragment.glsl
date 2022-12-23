#version 330 core

in vec3 o_positionWorld;
in vec3 o_normalWorld;
in vec2 o_uv0;
in mat3 o_TBN;

out vec4 FragColor;

uniform vec3 cameraPosition;
uniform samplerCube skybox;

struct MaterialData
{
	vec3 specular;

    sampler2D normalMap;
    bool useNormalMap;
};
uniform MaterialData materialData;

void main() 
{
    vec3 normal = o_normalWorld;
    if(materialData.useNormalMap){
    //Calculate normal
        vec3 texelNormalMap = texture(materialData.normalMap, o_uv0).rgb*2.0-1.0;
        normal = normalize(o_TBN * texelNormalMap);
    }

    vec3 _incident = normalize(o_positionWorld-cameraPosition);
    vec3 _reflect = reflect(_incident, normal);
    FragColor = vec4(texture(skybox, _reflect).rgb * materialData.specular, 1.0);
}
