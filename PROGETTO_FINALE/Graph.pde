class Graph {

  void addNode(Node node) {
    if (!nodes.contains(node)) {
      nodes.add(node);
    }
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
}





/* Il contenuto sottostante di questo file è stato trovato nel sito sotto citato*/

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */
