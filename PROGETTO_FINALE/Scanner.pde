void scan(float x, float y, float len_max, color colore) {

  float xi, yi, xi_0, yi_0;
  float len_x = floor_x/2;
  float len_y = floor_y/2;



  pushMatrix();
  translate(x, y);     //mi pongo nel SR del roomba
  len_x = cos(alpha)*len_max;
  len_y = sin(alpha)*len_max;


  stroke(colore);
  stroke(#6DCEF0);

  fill(255);
  stroke(255);
  circle(len_x, len_y, 5);

  //xi,yi sono le coordinate del punto verde sul foglio appunti progetto
  //xi,yi sono espresse rispetto a SRroomba

  if (intersectionObstacles(x, y, len_x, len_y)) {
    xi = intersectionX;
    yi = intersectionY;
  } else {
    intersectionWall(x, y, len_x, len_y);
    xi = intersectionX;
    yi = intersectionY;
  }


  stroke(0, 255, 0);
  line(0, 0, xi, yi);

  stroke(255);
  circle(xi, yi, 5);
  stroke(180, 0, 0);

  line(0, 0, xi, yi);
  //println(xi, yi);

  xi_0 = xi + x;        //coordinate di xi rispetto a SR0
  yi_0 = yi + y;
  detect_vert(xi_0, yi_0);



  stroke(255);
  noStroke();
  popMatrix(); //mi riporto alle coordinate inerziali

  fill(0, 0, 255);
  //circle(x_vert[0], y_vert[0], 30);  // vertice rilevato

  fill(0);
  alpha = (alpha + 0.005) %(2*PI);
}

void detect_vert(float xi, float yi) {

  float m_i2_i1, m_i1_i;

  m_i2_i1 = (y_prev[1]-y_prev[0])/(x_prev[1]-x_prev[0]);
  m_i1_i = (yi - y_prev[1])/(xi - x_prev[1]);

  if (m_i1_i > m_i2_i1) {
    x_vert[0] = x_prev[1];
    y_vert[0] = y_prev[1];
  }

  x_prev[0] = x_prev[1];
  y_prev[0] = y_prev[1];
  x_prev[1] = xi;
  y_prev[1] = yi;
}
