void make_tree(Node current) {

  int s = nodes.size();
  String s_lab = String.valueOf(s);
  float toll = 8;

  Node n = new Node(s_lab, x_vert, y_vert);
  /*modificare: node n non deve prendere esattamente x_vert e y_vert, ma questi con un offset per far
   stare il roomba fuori l'ostacolo*/

  for (Node ni : nodes) {

    if (abs(ni.x -x_vert)< toll && abs(ni.y-y_vert)<toll) {
      //se già esiste, o se è sufficientemente vicino ad un vertice già esistente
      //tree.linkNodes(ni, current);   //se il nodo è già "presente", crea solo arco
      return;
    }
  }
  tree.addChild(current, n);
}

void print_tree() {

  for (Node ni : nodes) {

    strokeWeight(5);
    fill(255);
    stroke(255);

    circle(ni.x, ni.y, r_node);
    fill(0);

    translate(0, 0, 20);
    textSize(40);
    text(ni.label, ni.x, ni.y);
    translate(0, 0, -20);

    for (Node near : ni.links) {
      strokeWeight(1);
      line(ni.x, ni.y, near.x, near.y);
    }
  }
}


/*la funzione find_path cerca primo antenato comune tra due nodi, e in particolare ne riporta un ArrayList contenente tutti i nodi
 che costituiscono il cammino per andare dal nodo source al nodo destination, passando al più per la root dell'albero */


ArrayList<Node> find_path(Node source, Node dest) {

  ArrayList<Node> path = new ArrayList<Node>();

  boolean exit = false;
  Node source_var = source;

  ArrayList<Node> s_path = new ArrayList<Node>();
  ArrayList<Node> d_path = new ArrayList<Node>();


  if (source.father != dest && dest.father != source) {
    while (source_var != tree.root && exit == false) {

      Node dest_var = dest;
      d_path.removeAll(d_path);
      d_path.add(dest_var);

      while (dest_var != tree.root && exit == false ) {

        if (source_var.father == dest_var.father) {
          d_path.add(0, dest_var.father);

          exit = true;
        } else {
          d_path.add(0, dest_var.father);
          dest_var = dest_var.father;
        }
      }

      s_path.add(source_var);

      source_var = source_var.father;
    }

    s_path.addAll(d_path);
    path = s_path;
  } else {

    path.add(source);
    path.add(dest);
  }

  //for (Node n : path) {
  //  println(n.label);
  //}
  return path;
}


float[] move(float x1, float y1, float x2, float y2) {

  float[] new_pos = {x1, y1};

  /*  IMPLEMENTAZIONE LEGGE ORARIA */

  float q_t = A*pow(t, 3) + B*pow(t, 2) + C*t + D;

  new_pos[0] = x1 + q_t*(x2-x1);
  new_pos[1] = y1 + q_t*(y2-y1);
  

  return new_pos;
}
