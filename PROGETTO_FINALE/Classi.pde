class Obstacle {
  
  public float r_obs;
  public float h_obs;
  public float pos_x_obs;
  public float pos_y_obs;
  private int id_num;

  Obstacle(float pos_x, float pos_y, float r_o, float h_o, int id) {

    pushMatrix();

    translate(pos_x, pos_y, h_o/2);
    fill(WOOD_2);
    drawCylinder(sides, r_o, h_o);
    
    r_obs = r_o;
    h_obs = h_o;
    pos_x_obs = pos_x;
    pos_y_obs = pos_y;
    
    
    
    popMatrix();
  }
  
  public int getID(){
  return this.id_num;
}
}
