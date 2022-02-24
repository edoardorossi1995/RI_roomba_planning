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

int i = 0;

// variabili SR
float lenAxis = 50;
float arrows = 0.1*lenAxis;

// variabili disegno ostacoli
int MAX_OB = 4;

int sides = 6;

float xot = -80;
float yot = -260;
float r_target = 10;
float h_target = 5;
boolean ist_t = true;

float xo1 = 100;
float yo1 = 100;
float ro1 = 150;
float ho1 = 10;
boolean is_target1 = false;

float xo2 = -100;
float yo2 = -100;
float ro2 = 90;
float ho2 = 10;
boolean is_target2 = false;

float xo3 = 100;
float yo3 = -100;
float ro3 = 100;
float ho3 = 10;
boolean is_target3 = false;

float[] x_obs = {xot, xo1, xo2, xo3};
float[] y_obs = {yot, yo1, yo2, yo3};
float[] r_obs = {r_target, ro1, ro2, ro3};
float[] h_obs = {h_target, ho1, ho2, ho3};

ArrayList<Obstacle> obstacle_ArrayList= new ArrayList<Obstacle>();

int id_target = 0;
int id_o1 = 1;
int id_o2 = 2;
int id_o3 = 3;



//variabili scanner
boolean s = false;   //variabile scanner
int num_iter = 800;
float start_alpha = (2*PI)/num_iter;
float alpha = start_alpha;
float laser_length = 600*sqrt(2);
float[] x_prev = {0, 0};   //coordinate dei punti i-1,i-2 RISPETTO A SR0
float[] y_prev = {0, 0};
float x_vert, y_vert;
boolean vertex_found = false;


//roomba
PShape roomba;
float pos_x_r = -180;
float pos_y_r = 100;
float r_r = 27;  //stima del diametro del roomba, con tolleranza, per evitare le collisioni

//parametri tree & movimento
float x_home = pos_x_r;
float y_home = pos_y_r;

Node current_node, next_node;
Tree tree;
ArrayList<Node> nodes;
float r_node = 10;
int exploring_node = 0;
boolean token = true;
ArrayList<Node> visited_nodes;
int j = 0;
boolean arrived = false;
ArrayList<Node> path;


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
  visited_nodes = new ArrayList<Node>();
  current_node = first_root;
  //for (Node n : nodes){
  //  println(n.label);
  //}
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

  obstacle_factory(xo1, yo1, ro1, ho1, id_o1, PI/3, is_target1);
  obstacle_factory(xo2, yo2, ro2, ho2, id_o2, PI/4, is_target2);
  obstacle_factory(xo3, yo3, ro3, ho3, id_o3, -PI/6, is_target3 );

  fill(GREEN);
  obstacle_factory(xot, yot, r_target, h_target, id_target, PI/12, ist_t);



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

    //fase di scan

    s = scan(pos_x_r, pos_y_r, laser_length, RED);
    if (vertex_found) {
      //aggiungo nodo solo quando trovo un nuovo vertice
      make_tree(current_node); //funzione che aggiunge il vertice eventualmente detectato ai links del current node
      vertex_found = false;
    }
    print_tree();

    if (s) {

      // cambia token quando lo scanner trova il target, e lo passa all'else responsabile della fase di movimento

      token = false;
    }

    if (alpha >= 0 && alpha <start_alpha ) {  //ciclo di scan completo => cambia token per muoversi

      token = false;
      arrived = false;

      //inizializza il path una volta che lo scan è finito per preparare il percorso
      j = 0;
      exploring_node++;
      next_node = nodes.get(exploring_node);

      path = find_path(current_node, next_node);
    }
  } else {
    //fase di movimento

    if (!s) {
      //scan terminato, target non trovato



      if (!arrived) {

        for (Node n : path) {
          println(n.label);
        }
        println("//////");

        print_tree();

        float x1, x2, y1, y2;

        x1 = path.get(j).x;
        y1 = path.get(j).y;
        x2 = path.get(j+1).x;
        y2 = path.get(j+1).y;

        float[] new_pos = move(x1, y1, x2, y2);

        pos_x_r = new_pos[0];
        pos_y_r = new_pos[1];





        //delay(2000);
        //pos_x_r = path.get(j).x;
        //pos_y_r = path.get(j).y;

        if (x1 == x2 && y1 == y2) {
          j++;
        }


        if (j == path.size() - 1) {
          /* se sono arrivato all'ultimo nodo dell'array path */
          //arrived = true;

          current_node = next_node;
          pos_x_r = current_node.x;
          pos_y_r = current_node.y;

          token = true;
        }
      }
    } else {  // qui ci dovrà essere il reset del target e del grafo


      pos_x_r = xot;
      pos_y_r = yot;
      token = true;
    }
  }

  //movimento => cambio nodo



  fill(0);

  popMatrix();
  noStroke();
  i++;
}
