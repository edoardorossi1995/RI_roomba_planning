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
      tree.linkNodes(ni, current);   //se il nodo è già "presente", crea solo arco
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
