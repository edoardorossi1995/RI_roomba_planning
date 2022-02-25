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
}
