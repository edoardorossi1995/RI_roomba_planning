class Node {

  public ArrayList<Node> links = new ArrayList<Node>();
  public String label;

  public float x;
  public float y;
  public float r;
  public Node father;

  /* Le coordinate _x e _y sono prese rispetto a SR0 */
  Node(String _label, float _x, float _y) {
    label=_label;
    x=_x;
    y=_y;
  }

  public boolean equals(Object obj) {
    return (this.label.equals(((Node)obj).label) && this.x == (((Node)obj).x) && this.y == (((Node)obj).y));
  }


  void addLink(Node n) {
    if (!links.contains(n)) {
      links.add(n);
    }
  }

  ArrayList<Node> getIncomingLinks() {
    return links;
  }

  int getLinksCount() {
    return links.size();
  }

  //boolean equals(Node other) {
  //  if (this==other) {
  //    return true;
  //  }
  //  return (this.x == other.x && this.y == other.y);
  //}

  //public boolean my_contains(ArrayList<Node> node_list) {

  //  println("size pre contain:" + node_list.size());
  //  for (Node n : node_list) {
  //    if (n.equals(this)) {
  //      println("1 eq ok");
  //      if (this.equals(n)) {
  //        println("2 eq ok");
  //        return true;
  //      } else {
  //        println("2 non ok");
  //      }
  //    } else {
  //      println("1 non ok");
  //    }
  //  }
  //  println("non entro da nessuna parte");
  //  return false;
  //}
}
