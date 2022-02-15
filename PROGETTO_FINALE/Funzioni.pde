/* la funzione collision() ritorna false se NON ci sono collisioni.
 Dunque il movimento sarà lecito se effettivamente il ritorno sarà negativo */

boolean collision(float x_r, float y_r, float r_r, float x_o, float y_o, float r_o ) {

  float distanza_centri = abs(sqrt(pow(x_r - x_o, 2) + pow(y_r-y_o, 2) ) );

  if (distanza_centri > r_r + r_o) {
    return false;
  } else {
    return true;
  }
}

/* la funzione globa_collision_roomba() verifica se ci sono collisioni del roomba con almeno un ostacolo o con i bordi della mappa */

boolean global_collision_roomba(float x_r, float y_r, float r_r, float[] x_obs, float[] y_obs, float[] r_obs) {

  int l = x_obs.length;

  for (int i = 0; i< l; i++) {

    if  (collision(x_r, y_r, r_r, x_obs[i], y_obs[i], r_obs[i])) {
      println("true");
      return true;
    }
  }

  if ((abs(x_r) + r_r >= floor_x/2)  || (abs(y_r) + r_r >= floor_y/2)) {
    println("true");
    return true;
  }

  println("false");
  return false;
}


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

  /*if (intersectionObstacles(x,y,len_x,len_y, )) {
    xi = intersectionX;
    yi = intersectionY;
    
  } else { 
    intersectionWall(x, y, len_x, len_y);
    xi = intersectionX;
    yi = intersectionY;
  }*/
  xi = 0;
  yi = 0;
  stroke(0, 255, 0);
  line(0, 0, xi, yi);
  stroke(255);


  /*if ((alpha>=0 && alpha<=PI/2) || (alpha>3*PI/2 && alpha<2*PI)) {
   xi = floor_x/2 - x;
   yi = tan(alpha)*xi;
   if (yi<(-floor_y/2 - y)) {
   yi = -floor_y/2-y;
   xi = yi/tan(alpha);
   }
   if (yi > (floor_y/2-y)) {
   yi = floor_y/2-y;
   xi = yi/tan(alpha);
   }
   } else {
   xi = - floor_y/2 - x;
   yi = tan(alpha)*xi;
   if (yi > (floor_y/2-y)) {
   yi = floor_y/2-y;
   xi = yi/tan(alpha);
   }
   if (yi<(-floor_y/2 - y)) {
   yi = -floor_y/2-y;
   xi = yi/tan(alpha);
   }
   }
   */

  stroke(180, 0, 0);

  circle(xi, yi, 5);
  line(0, 0, xi, yi);
  println(xi, yi);

  xi_0 = xi + x;        //coordinate di xi rispetto a SR0
  yi_0 = yi + y;
  detect_vert(xi_0, yi_0);



  stroke(255);
  noStroke();
  popMatrix(); //mi riporto alle coordinate inerziali

  fill(0, 0, 255);
  circle(x_vert[0], y_vert[0], 30);  // vertice rilevato

  fill(0);
  alpha = (alpha + 0.01) %(2*PI);
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


boolean intersectionLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  //parametrizzazione delle rette rispetto ai parametri t e u

  float t = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float u = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  //se entrambi compresi tra 0 e 1, c'è una collisione

  if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {


    intersectionX = x1 + (t * (x2-x1));
    intersectionY = y1 + (t * (y2-y1));
    fill(255);
    noStroke();
    circle(intersectionX, intersectionY, 20);

    return true;
  }


  return false;
}


boolean intersectionWall(float x, float y, float len_x, float len_y) {

  boolean dx, sx, up, down;

  dx = intersectionLine(floor_x/2 - x, -floor_y/2 - y, floor_x/2 - x, floor_y/2 - y, 0, 0, len_x, len_y);
  sx = intersectionLine(-floor_x/2 -x, -floor_y/2 -y, -floor_x/2 -x, floor_y/2 - y, 0, 0, len_x, len_y);
  up = intersectionLine(-floor_x/2 -x, -floor_y/2 - y, floor_x/2 - x, -floor_y/2 - y, 0, 0, len_x, len_y);
  down = intersectionLine(-floor_x/2 -x, floor_y/2 - y, floor_x/2 - x, floor_y/2 - y, 0, 0, len_x, len_y);

  if (sx || dx || up || down) {
    return true;
  } else {
    return false;
  }
}
