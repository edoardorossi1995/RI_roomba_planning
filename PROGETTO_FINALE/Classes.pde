class Obstacle {


  Obstacle(float pos_x, float pos_y, float r_o, float h_o) {

    pushMatrix();

    translate(pos_x, pos_y, h_o/2);
    fill(255);
    drawCylinder(sides, r_o, h_o);

    popMatrix();
  }
}
