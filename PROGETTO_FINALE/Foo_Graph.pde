void make_tree(Node current) {

  int s = nodes.size();
  String s_lab = String.valueOf(s);

  Node n = new Node(s_lab, x_vert, y_vert);

  for (Node ni : nodes) {
    if (ni.x == x_vert && ni.y == y_vert) {  //se già esiste
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
    text(ni.label, ni.x + 30, ni.y +10);

    for (Node near : ni.links) {
      line(ni.x, ni.y, near.x, near.y);
    }
  }
  
}
