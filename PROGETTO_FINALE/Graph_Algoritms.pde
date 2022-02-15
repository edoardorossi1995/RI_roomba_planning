/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Flow algorithm for drawing nodes in a circle
 */
class CircleFlowAlgorithm implements FlowAlgorithm
{
  // draw all nodes in a big circle,
  // without trying to find the best
  // arrangement possible.

  boolean reflow(DirectedGraph g)
  {
    float interval = 2*PI / (float)g.size();
    int cx = width/2;
    int cy = height/2;
    float vl = cx - (2*g.getNode(0).r1) - 10;
    for (int a=0; a<g.size(); a++)
    {
      int[] nc = rotateCoordinate(vl, 0, (float)a*interval);
      g.getNode(a).x = cx+nc[0];
      g.getNode(a).y = cy+nc[1];
    }
    return true;
  }
}



// this is the interface for graph reflowing algorithms
interface FlowAlgorithm {
  // returns "true" if done, or "false" if not done
  boolean reflow(DirectedGraph g);
}


/**
 * Flow algorithm that positions nodes by
 * prentending the links are elastic. This
 * is a multiple-step algorithm, and has
 * to be run several times before it's "done".
 */
class ForceDirectedFlowAlgorithm implements FlowAlgorithm
{
  float min_size = 80.0;
  float elasticity = 200.0;
  void setElasticity(float e) {
    elasticity = e;
  }

  float repulsion = 4.0;
  void setRepulsion(float r) {
    repulsion = r;
  }

  // this is actually a simplified force
  // directed algorithm, taking into account
  // only incoming links.

  boolean reflow(DirectedGraph g)
  {
    ArrayList<Node> nodes = g.getNodes();
    int reset = 0;
    for (Node n : nodes)
    {
      ArrayList<Node> incoming = n.getIncomingLinks();
      ArrayList<Node> outgoing = n.getOutgoingLinks();
      // compute the total push force acting on this node
      int dx = 0;
      int dy = 0;
      for (Node ni : incoming) {
        dx += (ni.x-n.x);
        dy += (ni.y-n.y);
      }
      float len = sqrt(dx*dx + dy*dy);
      float angle = getDirection(dx, dy);
      int[] motion = rotateCoordinate(0.9*repulsion, 0.0, angle);
      // move node
      int px = n.x;
      int py = n.y;
      n.x += motion[0];
      n.y += motion[1];
      if (n.x<0) {
        n.x=0;
      } else if (n.x>width) {
        n.x=width;
      }
      if (n.y<0) {
        n.y=0;
      } else if (n.y>height) {
        n.y=height;
      }
      // undo repositioning if elasticity is violated
      float shortest = n.getShortestLinkLength();
      if (shortest<min_size || shortest>elasticity*2) {
        reset++;
        n.x=px;
        n.y=py;
      }
    }
    return reset==nodes.size();
  }
}


/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Flow algorithm for trees - only works for Trees
 */
class TreeFlowAlgorithm implements FlowAlgorithm
{

  // tree layout is fairly simpe: segment
  // the screen into as many vertical strips
  // as the tree is deep, then at every level
  // segment a strip in as many horizontal
  // bins as there are nodes at that depth.

  boolean reflow(DirectedGraph g)
  {
    if (g instanceof Tree) {
      Tree t = (Tree) g;
      int depth = t.getDepth();
      int vstep = (height-20)/depth;
      int vpos = 30;

      Node first = t.root;
      first.x = width/2;
      first.y = vpos;

      // breadth-first iteration
      ArrayList<Node> children = t.root.getOutgoingLinks();
      while (children.size()>0)
      {
        vpos += vstep;
        int cnum = children.size();
        int hstep = (width-20) / cnum;
        int hpos = 10 + (hstep/2);
        ArrayList<Node> newnodes = new ArrayList<Node>();
        for (Node child : children) {
          child.x = hpos;
          child.y = vpos;
          addAll(newnodes, child.getOutgoingLinks());
          hpos += hstep;
        }
        children = newnodes;
      }
    }
    return true;
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// =============================================
//      Some universal helper functions
// =============================================

// universal helper function: get the angle (in radians) for a particular dx/dy
float getDirection(double dx, double dy) {
  // quadrant offsets
  double d1 = 0.0;
  double d2 = PI/2.0;
  double d3 = PI;
  double d4 = 3.0*PI/2.0;
  // compute angle basd on dx and dy values
  double angle = 0;
  float adx = abs((float)dx);
  float ady = abs((float)dy);
  // Vertical lines are one of two angles
  if (dx==0) {
    angle = (dy>=0? d2 : d4);
  }
  // Horizontal lines are also one of two angles
  else if (dy==0) {
    angle = (dx>=0? d1 : d3);
  }
  // The rest requires trigonometry (note: two use dx/dy and two use dy/dx!)
  else if (dx>0 && dy>0) {
    angle = d1 + atan(ady/adx);
  }    // direction: X+, Y+
  else if (dx<0 && dy>0) {
    angle = d2 + atan(adx/ady);
  }    // direction: X-, Y+
  else if (dx<0 && dy<0) {
    angle = d3 + atan(ady/adx);
  }    // direction: X-, Y-
  else if (dx>0 && dy<0) {
    angle = d4 + atan(adx/ady);
  }    // direction: X+, Y-
  // return directionality in positive radians
  return (float)(angle + 2*PI)%(2*PI);
}

// universal helper function: rotate a coordinate over (0,0) by [angle] radians
int[] rotateCoordinate(float x, float y, float angle) {
  int[] rc = {0, 0};
  rc[0] = (int)(x*cos(angle) - y*sin(angle));
  rc[1] = (int)(x*sin(angle) + y*cos(angle));
  return rc;
}

// universal helper function for Processing.js - 1.1 does not support ArrayList.addAll yet
void addAll(ArrayList a, ArrayList b) {
  for (Object o : b) {
    a.add(o);
  }
}
