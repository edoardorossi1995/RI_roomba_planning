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


  float sign_x =1;
  float sign_y=1;
  float len_x = floor_x/2;
  float len_y = floor_y/2;
  float x_cap = floor_x/2;
  float y_cap = floor_y/2;
  float m1 = (len_y)/(len_x);



  // direzione del laser
  //len_max = len_max - sqrt(pow(x,2) + pow(y,2));


  if (alpha >=0 && alpha < PI/2) {
    sign_x = 1;
    sign_y = 1;

    //len_x = min((x+cos(alpha)*len_max), (floor_x)/2);
    //len_y = min((y+sin(alpha)*len_max), (floor_y)/2);
  } else if (alpha >= PI/2 && alpha < PI) {
    sign_x = -1;
    sign_y = 1;

    //len_x = max((x+cos(alpha)*len_max), (-floor_x)/2);
    //len_y = min((y+sin(alpha)*len_max), (floor_y)/2);
  } else if (alpha >= PI && alpha < 3*PI/2) {
    sign_x = -1;
    sign_y = -1;

    //len_x = x+cos(alpha)*len_max;
    //len_y = y+sin(alpha)*len_max;
  } else /* (alpha >= 3*PI/2 && alpha < 2*PI)*/ {
    sign_x = 1;
    sign_y = -1;

    //len_x = min((x+cos(alpha)*len_max), (floor_x)/2);
    //len_y = max((y+sin(alpha)*len_max), (-floor_y)/2);
  }

  len_x = (x+cos(alpha)*len_max);
  len_y = (y+sin(alpha)*len_max);

  //if (len_y > len_x ) {

  //  y_cap = floor_y/2;
  //  x_cap = sqrt(pow(y_cap/sin(alpha), 2)-pow(y_cap, 2));
  //} else if (len_y == len_x) {
  //  y_cap = floor_y/2;
  //  x_cap = floor_x/2;
  //} else {  //

  //  x_cap = floor_x/2;
  //  y_cap = sqrt(pow(x_cap/sin(alpha), 2)-pow(x_cap, 2));
  //}



  stroke(colore);
  line(x, y, len_x, len_y);
  stroke(#6DCEF0);

  fill(255);
  stroke(255);
  circle(len_x, len_y, 5);

  stroke(0);
  float xx = 300;
  line(x, y, xx, m1*xx);
  stroke(255);
  //line(x, y, xx, m2*xx);
  noStroke();



  fill(0);

  alpha = alpha + 0.008;
  if (alpha > 2*PI) {
    alpha = alpha - 2*PI;
  }
  //if (alpha>=3*PI/4) {
  //  alpha = PI/4;
  //}
}
