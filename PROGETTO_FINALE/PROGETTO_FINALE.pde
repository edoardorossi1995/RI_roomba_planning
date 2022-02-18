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
int MAX_OB = 3;

int sides = 6;
float xo1 = 100;
float yo1 = 100;
float ro1 = 150;
float ho1 = 10;

float xo2 = -100;
float yo2 = -100;
float ro2 = 90;
float ho2 = 10;

float xo3 = 100;
float yo3 = -100;
float ro3 = 100;
float ho3 = 10;

float[] x_obs = {xo1, xo2, xo3};
float[] y_obs = {yo1, yo2, yo3};
float[] r_obs = {ro1, ro2, ro3};
float[] h_obs = {ho1, ho2, ho3};

ArrayList<Obstacle> obstacle_ArrayList= new ArrayList<Obstacle>();

int id_o1 = 1;
int id_o2 = 2;
int id_o3 = 3;


//variabili scanner
int num_iter = 500;
float start_alpha = PI/num_iter;
float alpha = start_alpha;
float laser_length = 600*sqrt(2);
float[] x_prev = {0, 0};   //coordinate dei punti i-1,i-2 RISPETTO A SR0
float[] y_prev = {0, 0};
float x_vert, y_vert;


//roomba
PShape roomba;
float pos_x_r = -180;
float pos_y_r = 100;
float r_r = 27;  //stima del raggio del roomba, con tolleranza, per evitare le collisioni

//parametri tree
float x_home = pos_x_r;
float y_home = pos_y_r;

Node current_node;
Tree tree;
ArrayList<Node> nodes;
float r_node = 10;

boolean token = true;


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

  Node first_root = new Node("source", x_home, y_home);
  nodes = new ArrayList<Node>();
  tree = new Tree(first_root);
  current_node = first_root;
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

  obstacle_factory(xo1, yo1, ro1, ho1, id_o1, PI);
  obstacle_factory(xo2, yo2, ro2, ho2, id_o2, PI);
  obstacle_factory(xo3, yo3, ro3, ho3, id_o3, -PI);


  fill(10, 100, 255);
  stroke(0);


  pushMatrix();
  translate(0, 0, 8);
  fill(DARK_GREY);
  circle(pos_x_r, pos_y_r, r_r); //roomba stilizzato
  /*shape(roomba, pos_x_r, pos_y_r);
   roomba.setFill(DARK_GREY);*/
  popMatrix();
  fill(0);


  //global_collision_roomba(pos_x_r, pos_y_r, r_r, x_obs, y_obs, r_obs);
  strokeWeight(3);
  if (token) {
    scan(pos_x_r, pos_y_r, laser_length, RED);
    make_tree(current_node);
    print_tree();
    if (alpha >= 0 && alpha <start_alpha) {  //ciclo di scan completo
      token = false;
    }
  } else {
    current_node = nodes.get(13);
    pos_x_r = current_node.x;
    pos_y_r = current_node.y;
    token = true;
  }

  //movimento => cambio nodo
  println(nodes.size());



  fill(0);

  popMatrix();
  noStroke();
}
