/* Il contenuto di questo file è stato trovato nel sito sotto citato*/

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// this class models a directed graph, consisting of any number of nodes
class DirectedGraph
{
  ArrayList<Node> nodes = new ArrayList<Node>();
  FlowAlgorithm flower = new CircleFlowAlgorithm();

  void setFlowAlgorithm(FlowAlgorithm f) {
    flower = f;
  }

  void addNode(Node node) {
    if (!nodes.contains(node)) {
      nodes.add(node);
    }
  }

  int size() {
    return nodes.size();
  }

  boolean linkNodes(Node n1, Node n2) {
    if (nodes.contains(n1) && nodes.contains(n2)) {
      n1.addOutgoingLink(n2);
      n2.addIncomingLink(n1);
      return true;
    }
    return false;
  }

  Node getNode(int index) {
    return nodes.get(index);
  }

  ArrayList<Node> getNodes() {
    return nodes;
  }

  ArrayList<Node> getRoots() {
    ArrayList<Node> roots = new ArrayList<Node>();
    for (Node n : nodes) {
      if (n.getIncomingLinksCount()==0) {
        roots.add(n);
      }
    }
    return roots;
  }

  ArrayList<Node> getLeaves() {
    ArrayList<Node> leaves = new ArrayList<Node>();
    for (Node n : nodes) {
      if (n.getOutgoingLinksCount()==0) {
        leaves.add(n);
      }
    }
    return leaves;
  }

  // the method most people will care about
  boolean reflow() {
    return flower.reflow(this);
  }

  // this does nothing other than tell nodes to draw themselves.
  void draw() {
    for (Node n : nodes) {
      n.draw();
    }
  }
}

// This is a generic node in a graph
class Node
{
  ArrayList<Node> inlinks = new ArrayList<Node>();
  ArrayList<Node> outlinks = new ArrayList<Node>();

  String label;

  Node(String _label, int _x, int _y) {
    label=_label;
    x=_x;
    y=_y;
    r1=5;
    r2=5;
  }

  void addIncomingLink(Node n) {
    if (!inlinks.contains(n)) {
      inlinks.add(n);
    }
  }

  ArrayList<Node> getIncomingLinks() {
    return inlinks;
  }

  int getIncomingLinksCount() {
    return inlinks.size();
  }

  void addOutgoingLink(Node n) {
    if (!outlinks.contains(n)) {
      outlinks.add(n);
    }
  }

  ArrayList<Node> getOutgoingLinks() {
    return outlinks;
  }

  int getOutgoingLinksCount() {
    return outlinks.size();
  }

  float getShortestLinkLength() {
    if (inlinks.size()==0 && outlinks.size()==0) {
      return -1;
    }
    float l = 100;
    for (Node inode : inlinks) {
      int dx = inode.x-x;
      int dy = inode.y-y;
      float il = sqrt(dx*dx + dy*dy);
      if (il<l) {
        l=il;
      }
    }
    for (Node onode : outlinks) {
      int dx = onode.x-x;
      int dy = onode.y-y;
      float ol = sqrt(dx*dx + dy*dy);
      if (ol<l) {
        l=ol;
      }
    }
    return l;
  }

  boolean equals(Node other) {
    if (this==other) return true;
    return label.equals(other.label);
  }

  // visualisation-specific
  int x=0;
  int y=0;
  int r1=10;
  int r2=10;

  void setPosition(int _x, int _y) {
    x=_x;
    y=_y;
  }

  void setRadii(int _r1, int _r2) {
    r1=_r1;
    r2=_r2;
  }

  void draw() {
    stroke(0);
    fill(255);
    for (Node o : outlinks) {
      drawArrow(x, y, o.x, o.y);
    }
    ellipse(x, y, r1*2, r2*2);
    fill(50, 50, 255);
    text(label, x+r1*2, y+r2*2);
  }

  int[] arrowhead = {0, -4, 0, 4, 7, 0};
  void drawArrow(int x, int y, int ox, int oy)
  {
    int dx=ox-x;
    int dy=oy-y;
    float angle = getDirection(dx, dy);
    float vl = sqrt(dx*dx+dy*dy) - sqrt(r1*r1+r2*r2)*1.5;
    int[] end = rotateCoordinate(vl, 0, angle);
    line(x, y, x+end[0], y+end[1]);
    drawArrowHead(x+end[0], y+end[1], angle);
  }
  void drawArrowHead(int ox, int oy, float angle) {
    int[] rc1 = rotateCoordinate(arrowhead[0], arrowhead[1], angle);
    int[] rc2 = rotateCoordinate(arrowhead[2], arrowhead[3], angle);
    int[] rc3 = rotateCoordinate(arrowhead[4], arrowhead[5], angle);
    int[] narrow = {ox+ rc1[0], oy+ rc1[1], ox+ rc2[0], oy+ rc2[1], ox+ rc3[0], oy+ rc3[1]};
    stroke(0);
    fill(255);
    triangle(narrow[0], narrow[1], narrow[2], narrow[3], narrow[4], narrow[5]);
  }
}

class Tree extends DirectedGraph
{
  Node root;
  Tree(Node r) {
    root = r;
    nodes.add(root);
    flower = new TreeFlowAlgorithm();
  }

  Node getRoot() {
    return root;
  }

  void addChild(Node parent, Node child) {
    nodes.add(child);
    linkNodes(parent, child);
  }

  int getDepth() {
    return getDepth(root);
  }

  int getDepth(Node r)
  {
    if (r.getOutgoingLinksCount()==0) return 1;
    int d = 0;
    ArrayList<Node> outgoing = r.getOutgoingLinks();
    for (Node child : outgoing) {
      int dc = getDepth(child);
      if (dc>d) {
        d=dc;
      }
    }
    return 1+d;
  }
}
