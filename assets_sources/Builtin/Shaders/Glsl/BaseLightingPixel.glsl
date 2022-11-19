#ifdef GL_ES
precision highp float;
#endif

varying vec3 ps_fragPos;
varying vec3 ps_normal;
varying vec2 ps_texCoords;

struct Material
{
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};

struct DirLight
{
    vec3 direction;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct PointLight
{
    vec3 position;

    float constant;
    float linear;
    float quadratic;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform vec3 viewPos;
uniform Material material;
uniform PointLight pointLight;
uniform DirLight dirLight;

vec3 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir)
{
    vec3 lightDir = normalize(-light.direction);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // combine results
    vec3 ambient = light.ambient * vec3(texture2D(material.diffuse, ps_texCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture2D(material.diffuse, ps_texCoords));
    vec3 specular = light.specular * spec * vec3(texture2D(material.specular, ps_texCoords));
    return (ambient + diffuse + specular);
}

vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - fragPos);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));    
    // combine results
    vec3 ambient = light.ambient * vec3(texture2D(material.diffuse, ps_texCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture2D(material.diffuse, ps_texCoords));
    vec3 specular = light.specular * spec * vec3(texture2D(material.specular, ps_texCoords));
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
}

void main() 
{
    vec3 norm = normalize(ps_normal);
    vec3 viewDir = normalize(viewPos - ps_fragPos);
    
    vec3 result = CalcDirLight(dirLight, norm, viewDir);
    result += CalcPointLight(pointLight, norm, ps_fragPos, viewDir);

    gl_FragColor = vec4(result, 1.0);
	//if (gl_FragColor.w == 0.0)
	//	discard;
}
