
public class CoordinateFrame {
  
  protected PVector x;
  protected PVector y;
  protected PVector z;
  
  private PMatrix rotation;
  
  public CoordinateFrame() {
    rotation = new PMatrix3D();
    x = new PVector();
    y = new PVector();
    z = new PVector();
    reset();
  }
  
  public void reset() {
    x.set(1,0,0);
    y.set(0,1,0);
    z.set(0,0,1);
  }
  
  private void applyRotation() {
    rotation.mult(x,x);
    rotation.mult(y,y);
    rotation.mult(z,z);
  }
  
  public void rotateX(float angle) {
    rotation.reset();
    rotation.rotateX(angle);
    applyRotation();
  }
  
  public void rotateY(float angle) {
    rotation.reset();
    rotation.rotateY(angle);
    applyRotation();
  }
  
  public void rotateZ(float angle) {
    rotation.reset();
    rotation.rotateZ(angle);
    applyRotation();
  }
  
}
