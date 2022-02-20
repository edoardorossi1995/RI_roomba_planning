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


float[] intersectionLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  //parametrizzazione delle rette rispetto ai parametri t e u

  float[] ret = new float[3];      //ret[0] = 1 se c'è intersezione, ret[1] e ret[2] sono le coordinate del pt di intersezione

  float t = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float u = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  //se entrambi compresi tra 0 e 1, c'è una collisione

  if (t >=0 && t <= 1 && u >= 0 && u <= 1) {

    ret[0] = 1;
    ret[1] = x1 + (t * (x2-x1));
    ret[2] = y1 + (t * (y2-y1));
    fill(255);
    noStroke();
    //circle(intersectionX, intersectionY, 20);

    return ret;
  } else {
    ret[0] = 0;
    ret[1] = 0;
    ret[2] = 0;
    return ret;
  }
}


float[] intersectionWall(float x, float y, float len_x, float len_y) {

  float[] dx = new float[3];
  float[] sx = new float[3];
  float[] up = new float[3];
  float[] down = new float[3];

  float[] wall_collision = new float[3];
  wall_collision[0] = 0;
  wall_collision[1] = 0;
  wall_collision[2] = 0;

  dx = intersectionLine(floor_x/2 - x, -floor_y/2 - y, floor_x/2 - x, floor_y/2 - y, 0, 0, len_x, len_y);
  if (dx[0]==1) {
    wall_collision[0] = 1;
    wall_collision[1] = dx[1];
    wall_collision[2] = dx[2];
  }
  sx = intersectionLine(-floor_x/2 -x, -floor_y/2 -y, -floor_x/2 -x, floor_y/2 - y, 0, 0, len_x, len_y);
  if (sx[0]==1) {
    wall_collision[0] = 1;
    wall_collision[1] = sx[1];
    wall_collision[2] = sx[2];
  }
  up = intersectionLine(-floor_x/2 -x, -floor_y/2 - y, floor_x/2 - x, -floor_y/2 - y, 0, 0, len_x, len_y);
  if (up[0]==1) {
    wall_collision[0] = 1;
    wall_collision[1] = up[1];
    wall_collision[2] = up[2];
  }
  down = intersectionLine(-floor_x/2 -x, floor_y/2 - y, floor_x/2 - x, floor_y/2 - y, 0, 0, len_x, len_y);
  if (down[0]==1) {
    wall_collision[0] = 1;
    wall_collision[1] = down[1];
    wall_collision[2] = down[2];
  }

  return wall_collision;
}


float[] intersectionObstacles(float x, float y, float len_x, float len_y) {

  float[] dx = new float[3];
  float[] sx = new float[3];
  float[] up = new float[3];
  float[] down = new float[3];

  float[] closest_collision = new float[3];
  closest_collision[0] = 0;
  closest_collision[1] = 600000;
  closest_collision[2] = 600000;

  for (int i=0; i< obstacle_ArrayList.size(); i++) {

    Obstacle o = obstacle_ArrayList.get(i);

    /*il seguente blocco di controllo verifica se c'è un'intersezione di ritorno dalle intersectionLine con i contorni degli ostacoli.
     in particolare se la 0esima posizione sugli array è pari a 1, significa che c'è collisione, e le variabili globali intersectionX e intersection Y
     verranno impostate pari ai float in posizione 1 e 2. poi, tale valore sarà confrontato con i ritorni dalle collisioni successive, per tenere
     in memoria solamente la collisione con il bordo più vicino al roomba */

    sx = intersectionLine(o.vert_SR0_ph[0] -x, o.vert_SR0_ph[1] -y, o.vert_SR0_ph[4] -x, o.vert_SR0_ph[5] - y, 0, 0, len_x, len_y);
    if (sx[0]==1) {
      if (min_distance(sx[1], sx[2], closest_collision[1], closest_collision[2])) {
        closest_collision[0] = 1;
        closest_collision[1] = sx[1];
        closest_collision[2] = sx[2];
      }
    }
    dx = intersectionLine(o.vert_SR0_ph[0] - x, o.vert_SR0_ph[1] - y, o.vert_SR0_ph[2] - x, o.vert_SR0_ph[3] - y, 0, 0, len_x, len_y);
    if (dx[0]==1) {
      if (min_distance(dx[1], dx[2], closest_collision[1], closest_collision[2])) {
        closest_collision[0] = 1;
        closest_collision[1] = dx[1];
        closest_collision[2] = dx[2];
      }
    }
    up = intersectionLine(o.vert_SR0_ph[6] -x, o.vert_SR0_ph[7] -y, o.vert_SR0_ph[4] -x, o.vert_SR0_ph[5] - y, 0, 0, len_x, len_y);
    if (up[0]==1) {
      if (min_distance(up[1], up[2], closest_collision[1], closest_collision[2])) {
        closest_collision[0] = 1;
        closest_collision[1] = up[1];
        closest_collision[2] = up[2];
      }
    }
    down = intersectionLine(o.vert_SR0_ph[6] -x, o.vert_SR0_ph[7] -y, o.vert_SR0_ph[2] -x, o.vert_SR0_ph[3] - y, 0, 0, len_x, len_y);
    if (down[0]==1) {
      if (min_distance(down[1], down[2], closest_collision[1], closest_collision[2])) {
        closest_collision[0] = 1;
        closest_collision[1] = down[1];
        closest_collision[2] = down[2];
      }
    }
  }
  return closest_collision;
}



boolean min_distance(float x1, float y1, float x2, float y2) {

  if (sqrt(pow(x1, 2) + pow(y1, 2)) < sqrt(pow(x2, 2) + pow(y2, 2))) {
    return true;
  } else {
    return false;
  }
}





//funzione che, prese in igresso le coordinate inerziali di un punto, resistuisce l'id 
//dell'oggetto all'interno di cui si trova, oppure -1 se non appartiene a nessun oggetto
int is_in_obstacle(float x_0, float y_0){
  float x_1, y_1;
 for (Obstacle ob : obstacle_ArrayList){
   
 }
 
 return -1;

}
