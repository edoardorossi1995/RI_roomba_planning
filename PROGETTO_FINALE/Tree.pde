class Tree extends Graph {

  Node root;

  Tree(Node r) {
    super();
    root = r;
    nodes.add(root);
  }

  Node getRoot() {
    return root;
  }

  void addChild(Node parent, Node child) {
    nodes.add(child);
    linkNodes(parent, child);
  }
}
