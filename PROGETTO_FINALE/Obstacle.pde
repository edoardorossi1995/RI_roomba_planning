class Obstacle {


  public float r_obs;
  public float h_obs;
  public float pos_x_obs;
  public float pos_y_obs;
  private int id_num;
  public float phi;

  public float[] vert_array_SR_ob = new float[8];
  public float[] vert_SR0 = new float[8];

  public float[] vert_array_SR_ob_ph = new float[8];
  public float[] vert_SR0_ph = new float[8];
  





  Obstacle(float pos_x, float pos_y, float r_o, float h_o, int id, float beta) {

    pushMatrix();

    translate(pos_x, pos_y, h_o/2);
    rotateZ(beta);
    fill(WOOD_2);


    box(r_o, r_o, h_o);
    fill(DARK_GREY, 0);
    //box(r_o+r_r, r_o+r_r, h_o);  //secondo ostacolo, trasparente


    //coordinate rispetto a SR ostacolo
    vert_array_SR_ob[0] = -r_o/2;
    vert_array_SR_ob[1] = -r_o/2;
    vert_array_SR_ob[2] = r_o/2;
    vert_array_SR_ob[3] = -r_o/2;
    vert_array_SR_ob[4] = -r_o/2;
    vert_array_SR_ob[5] = r_o/2;
    vert_array_SR_ob[6] = r_o/2;
    vert_array_SR_ob[7] = r_o/2;

    vert_SR0[0] = (-r_o/2)*(cos(beta)-sin(beta))+pos_x;
    vert_SR0[1] = (-r_o/2)*(cos(beta)+sin(beta))+pos_y;
    vert_SR0[2] = (r_o/2)*(cos(beta)+sin(beta))+pos_x;
    vert_SR0[3] = (-r_o/2)*(cos(beta)-sin(beta))+pos_y;
    vert_SR0[4] = (-r_o/2)*(cos(beta)+sin(beta))+pos_x;
    vert_SR0[5] = (-r_o/2)*(-cos(beta)+sin(beta))+pos_y;
    vert_SR0[6] = (-r_o/2)*(-cos(beta)+sin(beta))+pos_x;
    vert_SR0[7] = (r_o/2)*(cos(beta)+sin(beta))+pos_y;


    //vert_array_SR_ob_ph[0] = -r_o/2-r_r/2;
    //vert_array_SR_ob_ph[1] = -r_o/2-r_r/2;
    //vert_array_SR_ob_ph[2] = r_o/2+r_r/2;
    //vert_array_SR_ob_ph[3] = -r_o/2-r_r/2;
    //vert_array_SR_ob_ph[4] = -r_o/2-r_r/2;
    //vert_array_SR_ob_ph[5] = r_o/2+r_r/2;
    //vert_array_SR_ob_ph[6] = r_o/2+r_r/2;
    //vert_array_SR_ob_ph[7] = r_o/2+r_r/2;
    
    
    //vert_SR0_ph[0] = (-r_o/2-r_r/2)*(cos(beta)-sin(beta))+pos_x;
    //vert_SR0_ph[1] = (-r_o/2-r_r/2)*(cos(beta)+sin(beta))+pos_y;
    //vert_SR0_ph[2] = (r_o/2+r_r/2)*(cos(beta)+sin(beta))+pos_x;
    //vert_SR0_ph[3] = (-r_o/2-r_r/2)*(cos(beta)-sin(beta))+pos_y;
    //vert_SR0_ph[4] = (-r_o/2-r_r/2)*(cos(beta)+sin(beta))+pos_x;
    //vert_SR0_ph[5] = (-r_o/2-r_r/2)*(-cos(beta)+sin(beta))+pos_y;
    //vert_SR0_ph[6] = (-r_o/2-r_r/2)*(-cos(beta)+sin(beta))+pos_x;
    //vert_SR0_ph[7] = (r_o/2+r_r/2)*(cos(beta)+sin(beta))+pos_y;






    //drawCylinder(sides, r_o, h_o);

    r_obs = r_o;
    h_obs = h_o;
    pos_x_obs = pos_x;
    pos_y_obs = pos_y;
    id_num = id;
    phi = beta;





    popMatrix();  //torno in SR inerziale
  }

  public int getID() {
    return this.id_num;
  }
}


void obstacle_factory(float pos_x, float pos_y, float r_o, float h_o, int id, float beta) {

  Obstacle ob = new Obstacle(pos_x, pos_y, r_o, h_o, id, beta);

  int num_ob = obstacle_ArrayList.size();

  if (num_ob < MAX_OB) {
    obstacle_ArrayList.add(ob);
  }

  /*if (obstacle_ArrayList.size()<20000) {
   println(obstacle_ArrayList.size());
   }*/
}
