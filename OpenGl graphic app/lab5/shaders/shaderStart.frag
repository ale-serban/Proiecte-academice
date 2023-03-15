#version 410 core

in vec3 fNormal;
in vec4 fPosEye;
in vec2 fTexCoords;

in vec4 fragPosLightSpace;

uniform sampler2D shadowMap;

out vec4 fColor;

//lighting
uniform	vec3 lightDir;
uniform	vec3 lightColor;

//texture
uniform sampler2D diffuseTexture;
uniform sampler2D specularTexture;

uniform vec3 pozitie_bec;
vec3 culoare_bec=vec3(1.0f,1.0f,1.0f);


vec3 ambient;
float ambientStrength = 0.2f;
vec3 diffuse;
vec3 specular;
float specularStrength = 0.5f;
float shininess = 32.0f;

float constant=0.07f;
float linear=0.0f;
float quadratic=0.6f;
uniform float lumina_stop;


void computeLightComponents()
{		
	vec3 cameraPosEye = vec3(0.0f);//in eye coordinates, the viewer is situated at the origin
	
	//transform normal
	vec3 normalEye = normalize(fNormal);	
	
	//compute light direction
	vec3 lightDirN = normalize(lightDir);
	
	//compute view direction 
	vec3 viewDirN = normalize(cameraPosEye - fPosEye.xyz);
		
	//compute ambient light
	ambient = ambientStrength * lightColor;
	
	//compute diffuse light
	diffuse = max(dot(normalEye, lightDirN), 0.0f) * lightColor;
	
	//compute specular light
	vec3 reflection = reflect(-lightDirN, normalEye);
	float specCoeff = pow(max(dot(viewDirN, reflection), 0.0f), shininess);
	specular = specularStrength * specCoeff * lightColor;

	
	lightDirN = normalize(pozitie_bec-fPosEye.xyz);
     float dist = length(pozitie_bec-fPosEye.xyz);
     float att = 1.0f / (constant + linear * dist + quadratic * (dist * dist))*lumina_stop;
	ambient += att * ambientStrength * culoare_bec;
	diffuse += att * max(dot(normalEye, lightDirN), 0.0f) * culoare_bec;


}

float computeShadow()
{
	// perform perspective divide
	vec3 normalizedCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
	
	// Transform to [0,1] range
	normalizedCoords = normalizedCoords * 0.5 + 0.5;
	
	// Get closest depth value from light's perspective
	float closestDepth = texture(shadowMap, normalizedCoords.xy).r;
	
	// Get depth of current fragment from light's perspective
	float currentDepth = normalizedCoords.z;
	
	// Check whether current frag pos is in shadow
	float shadow = currentDepth > closestDepth ? 1.0 : 0.0;
	
	return shadow;
}


float computeFog()
{
 float fogDensity = 0.035f;
 float fragmentDistance = length(fPosEye);
 float fogFactor = exp(-pow(fragmentDistance * fogDensity, 2));

 return clamp(fogFactor, 0.0f, 1.0f);
}

void main() 
{
	computeLightComponents();
	
	vec3 baseColor = vec3(0.9f, 0.35f, 0.0f);//orange
	
	ambient *= texture(diffuseTexture, fTexCoords).rgb;
	diffuse *= texture(diffuseTexture, fTexCoords).rgb;
	specular *= texture(specularTexture, fTexCoords).rgb;

	float shadow = computeShadow();
	vec3 color = min((ambient + (1.0f - shadow)*diffuse) + (1.0f - shadow)*specular, 1.0f);
    
	vec4 color4 = vec4(color.x, color.y, color.z, 1.0f);
	
    float fogFactor = computeFog();
	vec4 fogColor = vec4(0.5f, 0.5f, 0.5f, 1.0f);
	
	fColor = mix(fogColor, color4, fogFactor);
}
