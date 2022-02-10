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
