
uniform float skew_factor;
uniform float unskew_factor;

uniform vec2 res;

// camera information
uniform vec3 frame_x;
uniform vec3 frame_y;
uniform vec3 frame_z;
uniform vec3 pos;

// time since program started
uniform float time;

// random function inspired by @patriciogv's
float rand(vec3 st) {
	return fract(sin(dot(st.xyz,vec3(12.9898,78.233,471.170)))*43758.5453123);
}

float getSimplexNoise(vec3 coord, float scale) {

	// retrieve the scaled coordinates
	coord /= scale;
	
	// get the transformed coordinates
	vec3 tcoord = coord+vec3((coord.x+coord.y+coord.z)*skew_factor);
	
	float value = 0.0; // the final "height" of the coordinate
	
	// visit all four vertices in the squashed parallelogram
	for(int u=0;u<=1;u++) {
	for(int v=0;v<=1;v++) {
	for(int w=0;w<=1;w++) {
		
		vec3 vert = vec3(
				floor(tcoord.x)+float(u),
				floor(tcoord.y)+float(v),
				floor(tcoord.z)+float(w));
			
		// get the inversely transformed coordinates
		// this is the actual coordinate if you were to place it on
		// the screen
		vert += vec3(-(vert.x+vert.y+vert.z)*unskew_factor);
		
		float samp = rand(vert);
		float kern = max(0.0,0.7-length(vert-coord));
		
		value += samp*kern;
	}
	}
	}
	
	return value;
}

void main() {
	
	// color black by default
	gl_FragColor = vec4(vec3(0.0),1.0);
	
	// do sphere tracing
	vec2 scale = gl_FragCoord.xy/res*2.0-vec2(1.0);
	vec3 scale_offset = frame_x*scale.x+frame_y*scale.y;
	
	vec3 ray = pos+scale_offset*1.0;
	vec3 dir = frame_z+scale_offset*1.0;
	
	float len = 0;
	int steps = 0;
	
	float warp = time;
	vec3 offset0 = vec3(-0.11,0.22,0.14)*warp;
	vec3 offset1 = vec3(0.22,-0.24,0.23)*warp;
	vec3 offset2 = vec3(0.13,0.26,-0.32)*warp;
	vec3 offset3 = vec3(-0.24,0.28,0.11)*warp;
	
	bool hit = false;
	
	for(;steps<64;steps++) {
		
		float dst = 1e4;
		
		
		float tnoise = 0.0;
		tnoise += getSimplexNoise(ray,400.0)/2.;
		tnoise += getSimplexNoise(ray,211.0)/2.;
		float angle = tnoise*sin(ray.y/1000.0)*10.0;
		vec3 noise_coord = ray+vec3(sin(angle),0.0,cos(angle))*100.0;
		
		//vec3 noise_coord = ray;
		
		float snoise = 0.0;
		snoise += getSimplexNoise(noise_coord,6400.0)*10.0;
		snoise += getSimplexNoise(noise_coord,3200.0)*10.0;
		snoise += getSimplexNoise(noise_coord,1600.0)*10.0;
		
		snoise += getSimplexNoise(noise_coord,120.0)/2.;
		snoise += getSimplexNoise(noise_coord,70.0)/4.;
		snoise += getSimplexNoise(noise_coord,34.0)/8.;
		
		//snoise += getSimplexNoise(noise_coord,13.0)/16.;
		//snoise += getSimplexNoise(ray+offset3,5.0)/32.;
		
		float ground = (length(ray)-1000.0)*0.1;
		//float ground = ray.y*(0.9-getSimplexNoise(vec3(ray.x,0.0,ray.z),400.0)*4.8);
		//float ground = ray.y*0.1;
		//float ground = 1600.0;
		
		dst = min(dst,max(0.0,(-20.0+snoise)*120.0+ground-60.0));
		
		if(dst<1e-2) {
			hit = true;
			break;
		}
		
		len += dst;
		ray += normalize(dir)*dst;
	}
	
	float brightness = 1.0/(1.0+float(len)/270.0)*(float(steps)/64.);
	
	vec3 bg = vec3(1.0);
	vec3 fg = vec3(0.0);
	
	//vec3 fog_coord = vec3(ray.x,0.0,ray.z);
	vec3 fog_coord = ray;
	for(int i=0;i<3;i++) {
		
		float scale = float(i+1)*18.0;
		
		float snoise = 0.0;
		snoise += getSimplexNoise(fog_coord+offset3,120.0*scale)/2.;
		snoise += getSimplexNoise(fog_coord+offset2,70.0*scale)/4.;
		snoise += getSimplexNoise(fog_coord+offset1,34.0*scale)/8.;
		snoise += getSimplexNoise(fog_coord+offset1,13.0*scale)/16.;
		
		bg[i] += snoise*36.0;
	}
	
	gl_FragColor = vec4(bg*brightness+fg*(1.0-brightness),1.0);
	
}