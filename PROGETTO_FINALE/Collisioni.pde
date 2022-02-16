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
    //circle(intersectionX, intersectionY, 20);

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


boolean intersectionObstacles(float x, float y, float len_x, float len_y) {

  boolean dx, sx, up, down;


  for (int i=0; i< obstacle_ArrayList.size(); i++) {


    Obstacle o = obstacle_ArrayList.get(i);

    sx = intersectionLine(o.vert_SR0[0] -x, o.vert_SR0[1] -y, o.vert_SR0[4] -x, o.vert_SR0[5] - y, 0, 0, len_x, len_y);
    dx = intersectionLine(o.vert_SR0[0] - x, o.vert_SR0[1] - y, o.vert_SR0[2] - x, o.vert_SR0[3] - y, 0, 0, len_x, len_y);
    up = intersectionLine(o.vert_SR0[6] -x, o.vert_SR0[7] -y, o.vert_SR0[4] -x, o.vert_SR0[5] - y, 0, 0, len_x, len_y);
    down = intersectionLine(o.vert_SR0[6] -x, o.vert_SR0[7] -y, o.vert_SR0[2] -x, o.vert_SR0[3] - y, 0, 0, len_x, len_y);

    if (sx || dx || up || down) {
      return true;
    }
  }
  return false;
}
