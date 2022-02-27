/*  PROGETTO ROBOTICA INDUSTRIALE: pianificazione del moto di un robot in una mappa non nota, tramite realizzazione di un grafo di visibilità.
 
 Il flusso di esecuzione è il seguente:
 - fase di scan e individuazione del target, fino al verificarsi di una condizione tra target trovato o ciclo di scan di 2*PI terminato
 - per ogni terna di punti tali che le rette passanti per i punti 1,2 e 2,3 ha una differenza di pendenza sufficiente, si determina un vertice
 - il path viene inizializzato e il controllo passa alla parte di movimento
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
int MAX_OB = 3;

int sides = 6;

//Variabili target 
float xot = 200;
float yot = 170;
float r_target = 10;
float h_target = 5;
boolean ist_t = true;

//variabili obstacle 1 
float xo1 = 100;
float yo1 = 100;
float ro1 = 150;
float ho1 = 10;
boolean is_target1 = false;

//variabili obstacle 2
float xo2 = -100;
float yo2 = -100;
float ro2 = 90;
float ho2 = 10;
boolean is_target2 = false;

float xo3 = 140;
float yo3 = -140;
float ro3 = 100;
float ho3 = 10;
boolean is_target3 = false;

//variabili creazione interattiva ostacoli

float pos_xo = 0;
float pos_yo = 0;
float r_obs = 100;
float beta_obs = 0;
float h_obs = 10;
int id_o = 2;

int semaforo_obs = 0;
boolean sovrapposizione = false;


//float[] x_obs = {xot, xo1, xo2, xo3};
//float[] y_obs = {yot, yo1, yo2, yo3};
//float[] r_obs = {r_target, ro1, ro2, ro3};
//float[] h_obs = {h_target, ho1, ho2, ho3};

ArrayList<Obstacle> obstacle_ArrayList= new ArrayList<Obstacle>();

int id_target = 0;
int id_o1 = 1;
int id_o2 = 2;
int id_o3 = 3;

//variabile per determinare la fase di selezionamento degli ostacoli. se false, esegue il planning
boolean selezione_ostacoli = true;

//variabili scanner
boolean s = false;   //variabile scanner
int num_iter = 900;
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
Node target;
ArrayList<Node> nodes;
float r_node = 10;
int exploring_node = 0;
boolean token = true;
ArrayList<Node> visited_nodes;
int j = 0;
boolean arrived = false;
ArrayList<Node> path;
float x1, x2, y1, y2;
float A, B, C, D;


float t = 0; // timer globale
float Dt = 30;  //NON è un differenziale: tf = ti + Dt
float ti;


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
color WHITE_TABLE = color(220);
color LINK = #4BA240;
color ORANGE = #EA8D2F;
color TARGET = #9540A2;
color TEMP_BOX_RED = #8E3636;

int slack = 35;

void setup() {

  fullScreen(P3D);
  background(LIGHT_BLUE);
  //roomba = loadShape("iRobot_iCreate.obj");

  Node first_root = new Node("source", x_home, y_home);
  //Node target = new Node("target", xot, yot);
  nodes = new ArrayList<Node>();
  tree = new Tree(first_root);
  visited_nodes = new ArrayList<Node>();
  current_node = first_root;
}

void draw() {

  background(LIGHT_BLUE);


  pushMatrix();

  translate(width/2, height/2, -50);

  rotateY(-angoloY);
  rotateX(angoloX);

  rotateX(PI/4);
  rotateZ(PI/10);

  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(122, 122, 122);

  //creazione tavolo da lavoro
  fill(255);
  box(floor_x, floor_y, floor_z);

  // posizionamento sulla superficie del tavolo
  translate(0, 0, 5);
  SR3D();

  /* creazione target */
  obstacle_factory(xot, yot, r_target, h_target, id_target, PI/12, ist_t);

  /* creazione 2 ostacoli di default */
  obstacle_factory(xo1, yo1, ro1, ho1, id_o1, PI/4, is_target1);
  obstacle_factory(xo2, yo2, ro2, ho2, id_o2, 0, is_target2);




  for (Obstacle o : obstacle_ArrayList) {
    obstacle_factory(o.pos_x_obs, o.pos_y_obs, o.r_obs, o.h_obs, o.id_num, o.phi, o.is_t);
  }



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



  if (selezione_ostacoli) {

    noStroke();

    /*
    
     GESTIONE OSTACOLI INTERATTIVA:
     non entra nel flusso di planning
     
     */
    if (semaforo_obs != 0) {
      pushMatrix();
      translate(pos_xo, pos_yo, h_obs/2);
      rotateZ(beta_obs);

      fill(TEMP_BOX_RED);
      box(r_obs, r_obs, h_obs);
      fill(0, 0, 0, 20);
      box(r_obs+r_r, r_obs+r_r, h_obs-5);
      popMatrix();
    }
  } else {

    /* flusso di scan e planning */
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

        j = 0;
        exploring_node++;
        next_node = nodes.get(exploring_node);

        path = find_path(current_node, next_node);

        x1 = path.get(j).x;
        y1 = path.get(j).y;
        x2 = xot;
        y2 = yot;

        t = 0;
        ti = t;

        A = (2*pow(ti, 3)+3*Dt*pow(ti, 2))/(pow(Dt, 3));
        B = -(6*pow(ti, 2)+6*Dt*ti)/(pow(Dt, 3));
        C = (6*ti+3*Dt)/(pow(Dt, 3));
        D = -2/(pow(Dt, 3));
      }

      if (alpha >= 0 && alpha <start_alpha ) {  //ciclo di scan completo => cambia token per muoversi

        token = false;
        arrived = false;

        //inizializza il path una volta che lo scan è finito per preparare il percorso
        j = 0;
        exploring_node++;
        next_node = nodes.get(exploring_node);

        path = find_path(current_node, next_node);

        x1 = path.get(j).x;
        y1 = path.get(j).y;
        x2 = path.get(j+1).x;
        y2 = path.get(j+1).y;

        t = 0;
        ti = t;

        A = (2*pow(ti, 3)+3*Dt*pow(ti, 2))/(pow(Dt, 3));
        B = -(6*pow(ti, 2)+6*Dt*ti)/(pow(Dt, 3));
        C = (6*ti+3*Dt)/(pow(Dt, 3));
        D = -2/(pow(Dt, 3));
      }
    } else {
      //fase di movimento

      if (!s) {
        //scan terminato, target non trovato
        //visited_nodes.add(path.get(j));

        if (!arrived) {

          //for (Node n : path) {
          //  println(n.label);
          //}

          print_tree();


          float[] new_pos = move(x1, y1, x2, y2);

          pos_x_r = new_pos[0];
          pos_y_r = new_pos[1];

          float toll2 = 1;

          if (abs(pos_x_r - x2) < toll2 && abs(pos_y_r - y2) < toll2 ) {

            j++;

            if (j < (path.size() -1)) {

              /* se sono arrivato in un nodo non punto finale del path, inizializzo nuovamente le variabili di definizione traiettoria */



              x1 = path.get(j).x;
              y1 = path.get(j).y;
              x2 = path.get(j+1).x;
              y2 = path.get(j+1).y;

              t = 0;
              ti = t;

              A = (2*pow(ti, 3)+3*Dt*pow(ti, 2))/(pow(Dt, 3));
              B = -(6*pow(ti, 2)+6*Dt*ti)/(pow(Dt, 3));
              C = (6*ti+3*Dt)/(pow(Dt, 3));
              D = -2/(pow(Dt, 3));
            } else if (j == (path.size() - 1)) {
              print_tree();

              /* se sono arrivato all'ultimo nodo dell'array path */

              //arrived = true;

              current_node = next_node;
              //pos_x_r = current_node.x;
              //pos_y_r = current_node.y;

              token = true;
            }
          }
        }
      } else {  // if (s)

        //visited_nodes.add(target);


        float toll2 = 1;

        if (abs(pos_x_r - x2) < toll2 && abs(pos_y_r - y2) < toll2 ) {


          print_tree();
          //println(visited_nodes.size());
          //print_path(visited_nodes, TEMP_BOX_RED);
        } else {
          print_tree();
          float[] new_pos = move(x1, y1, x2, y2);
          pos_x_r = new_pos[0];
          pos_y_r = new_pos[1];
        }
      }
    }
  }




  fill(0);
  popMatrix();

  textSize(25);
  stroke(0);

  if (selezione_ostacoli) {
    text("ISTRUZIONI PER L'USO", 30, 30);
    if (semaforo_obs == 0) {
      text("Premere 'o' per avviare la creazione di un ostacolo", 30, 65);
    }
    if (semaforo_obs == 1) {
      text("Premere UP/DOWN per regolare la dimensione, LEFT/RIGHT per orientarlo", 30, 65);
      text("Premere TAB per procedere", 30, 100);
    }
    if (semaforo_obs == 2) {
      text("Premere UP/DOWN/LEFT/RIGHT per posizionarlo", 30, 65);
      text("Premere SHIFT per instanziare l'ostacolo", 30, 100);
    }
    if (sovrapposizione) {
      fill(RED);
      text("Sovrapposizione: posizionare l'ostacolo evitando sovrapposizioni con ostacoli già esistenti", 30, 135);
    }
    fill(0);

    fill(ROOMBA_GREEN);
    text("Premere ENTER per avviare l'esecuzione", 30, 170);
  }





  noStroke();

  t++;

  //println(obstacle_ArrayList.size());
  //for (Obstacle o : obstacle_ArrayList) {
  //  println("ID ostacolo = ", o.getID());
  //}
}
