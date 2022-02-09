/*  Roomba che deve raggiungere un target
 Ostacoli nella mappa, anche definibili a scelta/dinamicamente
 Robot al centro (3dof / cilindrico) che sposta il target
 */


// parametri visualizzazione
float angoloX = 0;
float angoloY = 0;
float angoloXpartenza = 0;
float angoloYpartenza = 0;

// variabili SR
float lenAxis = 50;
float arrows = 0.1*lenAxis;

// variabili disegno ostacoli
int sides = 12;

//roomba

PShape roomba;
float pos_x_r = 0;
float pos_y_r = 0;

// colors
color BIANCO_SFONDO = #E8E8E8;
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color LIGHT_BLUE = #6DCEF0;
color ROOMBA_GREEN = #198B00;


void setup() {

  fullScreen(P3D);
  background(BIANCO_SFONDO);
  roomba = loadShape("iRobot_iCreate.obj");
}

void draw() {

  background(BIANCO_SFONDO);

  pushMatrix();

  translate(width/2, height/2);

  rotateY(-angoloY);
  rotateX(angoloX);

  rotateX(PI/4);
  rotateZ(PI/10);
  fill(50);

  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(102, 102, 102);

  //creazione tavolo da lavoro
  box(600, 600, 10);

  // posizionamento sulla superficie del tavolo
  translate(0, 0, 5);
  SR3D();

  Obstacle obs1 = new Obstacle(100, 100,50,60);
  fill(10, 0, 255);
  stroke(155, 0, 50);

  pushMatrix();
  translate(0, 0, 8);
  shape(roomba, pos_x_r, pos_y_r);
  roomba.setFill(ROOMBA_GREEN);
  popMatrix();
  fill(0);
  noStroke();





  popMatrix();
}
