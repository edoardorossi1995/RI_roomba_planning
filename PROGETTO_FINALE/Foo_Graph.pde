void make_tree(Node current) {

  int s = nodes.size();
  String s_lab = String.valueOf(s);
  float toll = 5;

  Node n = new Node(s_lab, x_vert, y_vert);

  for (Node ni : nodes) {
    
    if (abs(ni.x -x_vert)< toll && abs(ni.y-y_vert)<toll) {  //se già esiste, o se è sufficientemente vicino ad un vertice già esistente
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
    
    translate(0, 0, 10);
    text(ni.label, ni.x, ni.y);
    translate(0, 0, -10);

    for (Node near : ni.links) {
      line(ni.x, ni.y, near.x, near.y);
    }
  }
}
