void mousePressed() {

  angoloYpartenza = angoloY + PI*mouseX/float(500);  //bisogna tramutare in radianti ==> moltiplico per PI. visto che
  //da un punto all'altro sono 500 radianti, divido per 500 così da avere un buon fattore di scala
  angoloXpartenza = angoloX + PI*mouseY/float(500);
}


void mouseDragged() {
  angoloY = angoloYpartenza - PI*mouseX/float(500);
  angoloX = angoloXpartenza - PI*mouseY/float(500);
}

void keyPressed() {


  // visual home
  if (key == 'h') {
    angoloX = 0;
    angoloY = 0;
    angoloXpartenza = 0;
    angoloYpartenza = 0;
  }

  if (selezione_ostacoli) {
    if (keyCode == ENTER ) {

      /* termina fase di crezione ostacoli */

      selezione_ostacoli = false;
    }
    if (semaforo_obs == 0) {

      if (key == 'o') {

        /* primo step di creazione ostacolo
         N.B. il cambio semaforo avviene per impedire la creazione di un nuovo ostacolo
         prima del completamento del precedente. */

        pos_xo = 0;
        pos_yo = 0;

        semaforo_obs = 1;
      }
    }
    if (semaforo_obs == 1) {
      /* forma ostacolo  */

      sovrapposizione = square_compenetration(pos_xo, pos_yo, r_obs, beta_obs);

      if (keyCode == UP) {
        r_obs  += 5;
      }
      if (keyCode == DOWN) {
        r_obs  -= 5;
      }
      if (keyCode == RIGHT) {
        beta_obs += 0.05;
      }
      if (keyCode == LEFT) {
        beta_obs -= 0.05;
      }

      if (keyCode == TAB) {
        semaforo_obs = 2;
      }
    }
    if (semaforo_obs == 2) {

      /* traslazione ostacolo NSWE */

      if (keyCode == UP) {
        pos_yo  -= 5;
      }
      if (keyCode == DOWN) {
        pos_yo  += 5;
      }
      if (keyCode == RIGHT) {
        pos_xo += 5;
      }
      if (keyCode == LEFT) {
        pos_xo -= 5;
      }


      sovrapposizione = square_compenetration(pos_xo, pos_yo, r_obs, beta_obs);


      if (keyCode == SHIFT && !(sovrapposizione)) {

        /* instansiazione dell'ostacolo */
        id_o ++;
        MAX_OB ++;

        obstacle_factory(pos_xo, pos_yo, r_obs, h_obs, id_o, beta_obs, false);

        semaforo_obs = 0;
      }
    }
  }

  if (key == '0') {
    if (print) {
      print = false;
    }
  }
  if (key == '9') {
    if (!print) {
      print = true;
    }
  }
}
