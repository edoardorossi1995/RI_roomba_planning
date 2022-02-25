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

}
