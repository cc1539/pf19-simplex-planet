
Camera camera;
PShader shader;

boolean[] input = new boolean[256];

float time_speed = 0;
float time = 0;

void setup() {
  
  surface.setTitle("simplex planet");
  
  size(640,640,P2D);
  noSmooth();
  
  camera = new Camera();
  camera.position.z = -24000;
  
  shader = loadShader("shader.glsl");
  shader.set("res",(float)width,(float)height);
  
  int N = 3;
  shader.set("skew_factor",(sqrt(N+1.0)-1.0)/N);
  shader.set("unskew_factor",(1.0-1.0/sqrt(N+1.0))/N);
}

void keyPressed() {
  input[keyCode] = true;
}

void keyReleased() {
  input[keyCode] = false;
}

float turn_x;
float turn_y;

void draw() {
  
  float walk_speed = 100./frameRate;
  float turn_speed = 0.02;
  if(mousePressed) {
    turn_x += ((mouseX-pmouseX)*turn_speed-turn_x)*.2;
    turn_y += ((mouseY-pmouseY)*turn_speed-turn_y)*.2;
    //camera.turnX((mouseX-pmouseX)*turn_speed);
    //camera.turnY((mouseY-pmouseY)*turn_speed);
  } else {
    turn_x *= .8;
    turn_y *= .8;
  }
  camera.turnX(turn_x);
  camera.turnY(turn_y);
  if(input['w'-32]) { camera.walk( walk_speed); }
  if(input['s'-32]) { camera.walk(-walk_speed); }
  if(input['d'-32]) { camera.strafe( walk_speed); }
  if(input['a'-32]) { camera.strafe(-walk_speed); }
  if(input[32]) { camera.velocity.y += walk_speed; }
  if(input[16]) { camera.velocity.y -= walk_speed; }
  camera.drag(0.1);
  camera.move();
  
  camera.updateCoordinateFrame();
  
  // camera information
  shader.set("frame_x",camera.frame.x.x,camera.frame.x.y,camera.frame.x.z);
  shader.set("frame_y",camera.frame.y.x,camera.frame.y.y,camera.frame.y.z);
  shader.set("frame_z",camera.frame.z.x,camera.frame.z.y,camera.frame.z.z);
  shader.set("pos",camera.position);
  
  // time since program started
  shader.set("time",time);
  
  time_speed = 120;
  //time_speed += ((input['t'-32]?100:0)-time_speed)*0.1;
  time += time_speed;
  
  filter(shader);
  camera.drawGumball(30,25);
  
  surface.setTitle("FPS: "+frameRate);
}
