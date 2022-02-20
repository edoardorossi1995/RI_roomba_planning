void scan(float x, float y, float len_max, color colore) {    //x,y coordinate del roomba rispetto a SR0 

  float xi, yi, xi_0, yi_0;
  float len_x = floor_x/2;
  float len_y = floor_y/2;
  boolean same_obstacle;
  int detected_obs;



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

  float[] intersection_obstacles = intersectionObstacles(x, y, len_x, len_y);
  float[] intersection_wall = intersectionWall(x, y, len_x, len_y);


  if (intersection_obstacles[0] == 1) {
    xi = intersection_obstacles[1];
    yi = intersection_obstacles[2];

    //println(xi, yi);
  } else {
    //println("wall");
    //intersection_wall[0];  dal momento che se non interseca un ostacolo  SICURAMENTE ci sarà un intersezione col bordo
    xi = intersection_wall[1];
    yi = intersection_wall[2];
  }

  xi_0 = xi + x;        //coordinate di xi rispetto a SR0
  yi_0 = yi + y;

  detected_obs = is_in_obstacle(xi_0, yi_0);        //id dell'ostacolo su cui 'poggia' il laser

  if (is_in_obstacle(x, y) == detected_obs && (detected_obs != -1)) {        //se il laser e l'oggetto si trovano lungo 
    //i lati dello stesso oggetto same_obstacle è true
    same_obstacle = true;
  } else {
    same_obstacle = false;
  }





  if (!same_obstacle) {
    stroke(255);
    circle(xi, yi, 5);
    stroke(180, 0, 0);
    line(0, 0, xi, yi);
    stroke(0, 0, 255);
    detect_vert(xi_0, yi_0);
  }
  //println(is_in_obstacle(xi_0,yi_0));



  stroke(255);
  noStroke();
  popMatrix(); //mi riporto alle coordinate inerziali

  fill(0, 0, 255);
  if (alpha >= 2*(2*PI)/num_iter) {
    circle(x_vert, y_vert, 30);  // vertice rilevato
  }

  fill(0);
  alpha = (alpha + (2*PI)/num_iter) %(2*PI);
}

void detect_vert(float xi, float yi) {

  float m_i2_i1, m_i1_i;
  float threshold = 1.0/100;

  /* condizioni di verticalità NON FUNZIONA FIXARE*/

  if (x_prev[1] == x_prev[0]) {
    m_i2_i1 = 1000;
  } else {
    m_i2_i1 = (y_prev[1]-y_prev[0])/(x_prev[1]-x_prev[0]);
  }

  if (x_prev[1] == xi) {
    m_i1_i = 1000;
  } else {
    m_i1_i = (yi - y_prev[1])/(xi - x_prev[1]);
  }

  /* il valore 500 come upper bound è per trattare le coppie di punti a pendenza infinita */
  if (abs(m_i1_i - m_i2_i1)> threshold && (alpha >= 3*(2*PI)/num_iter)) { 
    vertex_found = true;
    x_vert = x_prev[1];
    y_vert = y_prev[1];
  }

  x_prev[0] = x_prev[1];
  y_prev[0] = y_prev[1];
  x_prev[1] = xi;
  y_prev[1] = yi;
}
