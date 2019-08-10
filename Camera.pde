
public class Camera {
  
  private CoordinateFrame frame;
  protected PVector position;
  protected PVector velocity;
  protected PVector rotation;
  
  public Camera() {
    frame = new CoordinateFrame();
    position = new PVector();
    velocity = new PVector();
    rotation = new PVector();
  }
  
  public void turnX(float angle) {
    rotation.y += angle;
  }
  
  public void turnY(float angle) {
    rotation.x += angle;
    rotation.x = min(max(rotation.x,-HALF_PI),HALF_PI);
  }
  
  public void walk(float speed) {
    velocity = velocity.add(frame.z.mult(speed));
  }
  
  public void strafe(float speed) {
    velocity = velocity.add(frame.x.mult(speed));
  }
  
  public void drag(float amount) {
    velocity = velocity.mult(1-amount);
  }
  
  public void move() {
    position = position.add(velocity);
  }
  
  private void updateCoordinateFrame() {
    frame.reset();
    frame.rotateZ(rotation.z);
    frame.rotateX(rotation.x);
    frame.rotateY(rotation.y);
  }
  
  public void drawGumball(float a, float b) {
    float x = width-a;
    float y = height-a;
    stroke(255,0,0); line(x,y,x+frame.x.x*b,y-frame.x.y*b);
    stroke(0,255,0); line(x,y,x+frame.y.x*b,y-frame.y.y*b);
    stroke(0,0,255); line(x,y,x+frame.z.x*b,y-frame.z.y*b);
  }
  
}
