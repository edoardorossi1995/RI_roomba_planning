/*  Roomba che deve raggiungere un target
 Ostacoli nella mappa, anche definibili a scelta/dinamicamente
 Robot al centro (3dof / cilindrico) che sposta il target
 
 Per grafo di visibilità: individuare i vertici come oggetti con coordinate note al sistema
 */


// parametri visualizzazione
float angoloX = 0;
float angoloY = 0;
float angoloXpartenza = 0;
float angoloYpartenza = 0;

// variabili stanza
float floor_x = 600;
float floor_y = 600;
float floor_z = 10;

//segmenti - pareti stanza


// variabili SR
float lenAxis = 50;
float arrows = 0.1*lenAxis;

// variabili disegno ostacoli
int sides = 6;
float xo1 = 100;
float yo1 = 100;
float ro1 = 50;
float ho1 = 60;

float xo2 = -100;
float yo2 = -100;
float ro2 = 40;
float ho2 = 90;

float[] x_obs = {xo1, xo2};
float[] y_obs = {yo1, yo2};
float[] r_obs = {ro1, ro2};
float[] h_obs = {ho1, ho2};

int id_o1 = 1;
int id_o2 = 2;


//variabili scanner
float alpha = 0;
float laser_length = 600*sqrt(2);
float[] x_prev = {0,0};   //coordinate dei punti i-1,i-2 RISPETTO A SR0
float[] y_prev = {0,0};
float[] x_vert = {0,0,0,0};
float[] y_vert = {0,0,0,0};

float intersectionX;
float intersectionY;

//roomba
PShape roomba;
float pos_x_r = 0;
float pos_y_r = 0;
float r_r = 27;  //stima del raggio del roomba, con tolleranza, per evitare le collisioni

// colors
color BIANCO_SFONDO = #E8E8E8;
color NERO_SFONDO = color(100);
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color LIGHT_BLUE = #6DCEF0;
color ROOMBA_GREEN = #198B00;
color WOOD_1 = #C19A6B;
color WOOD_2 = #663300;
color DARK_GREY = color(40);


void setup() {

  fullScreen(P3D);
  background(NERO_SFONDO);
  //roomba = loadShape("iRobot_iCreate.obj");
}

void draw() {

  background(NERO_SFONDO);


  pushMatrix();

  translate(width/2, height/2);

  rotateY(-angoloY);
  rotateX(angoloX);

  rotateX(PI/4);
  rotateZ(PI/10);

  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(102, 102, 102);

  //creazione tavolo da lavoro
  fill(WOOD_1);
  box(floor_x, floor_y, floor_z);

  // posizionamento sulla superficie del tavolo
  translate(0, 0, 5);
  SR3D();

  Obstacle obs1 = new Obstacle(xo1, yo1, ro1, ho1, id_o1,PI/4);
  fill(10, 100, 255);
  stroke(0);

  Obstacle obs2 = new Obstacle(xo2, yo2, ro2, ho2, id_o2,PI/8);

  pushMatrix();
  translate(0, 0, 8);
  fill(DARK_GREY);
  circle(pos_x_r,pos_y_r,r_r); //roomba stilizzato
  /*shape(roomba, pos_x_r, pos_y_r);
  roomba.setFill(DARK_GREY);*/
  popMatrix();
  fill(0);


  //global_collision_roomba(pos_x_r, pos_y_r, r_r, x_obs, y_obs, r_obs);
  strokeWeight(3);
  //scan(pos_x_r, pos_y_r, laser_length, RED);
  
  fill(0);

  popMatrix();
  noStroke();
}
