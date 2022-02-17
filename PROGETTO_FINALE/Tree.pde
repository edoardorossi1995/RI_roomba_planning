class Tree  {

  Node root;

  Tree(Node r) {
    root = r;
    nodes.add(root);
  }
  
  void addNode(Node node) {
    if (!nodes.contains(node)) {
      nodes.add(node);
    }
  }

  Node getRoot() {
    return root;
  }
  
  int size() {
    return nodes.size();
  }
  
  Node getNode(int index) {
    return nodes.get(index);
  }
  
  ArrayList<Node> getNodes() {
    return nodes;
  }
  
  boolean linkNodes(Node n1, Node n2) {
    if (nodes.contains(n1) && nodes.contains(n2)) {
      n1.addLink(n2);
      n2.addLink(n1);
      return true;
    }
    return false;
  }

  void addChild(Node parent, Node child) {
    nodes.add(child);
    linkNodes(parent, child);
  }
}
