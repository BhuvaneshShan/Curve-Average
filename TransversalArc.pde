boolean showTransArc = false;
class TransArc{
  ArrayList<pt> avgCur;
  ArrayList<pt> c1pt;
  ArrayList<pt> c2pt;
  TransArc(ArrayList<pt> ac, ArrayList<pt> c1p, ArrayList<pt> c2p){
    avgCur = new ArrayList<pt>(ac);
    c1pt = new ArrayList<pt>(c1p);
    c2pt = new ArrayList<pt>(c2p);
  } 
  void Copy(ArrayList<pt> ac, ArrayList<pt> c1p, ArrayList<pt> c2p){
    avgCur = new ArrayList<pt>(ac);
    c1pt = new ArrayList<pt>(c1p);
    c2pt = new ArrayList<pt>(c2p);
  } 
  void drawArc(){
    
    for(int i =0; i<avgCur.size(); i=i+5){
      pt m = avgCur.get(i);
      pt p = c1pt.get(i);
      pt q = c2pt.get(i);
      stroke(color(#B47637));
      strokeWeight(1);
      line(m.x,m.y,m.z,p.x,p.y,p.z);
      line(m.x,m.y,m.z,q.x,q.y,q.z);
     vec ptan = V(3,V(p,m));
      vec qtan = V(3,V(m,q));
      pt oldpt = P(p);
      for(float j=0;j<=1;j=j+0.01){
        pt newpt = hermitePoint(j,p,ptan, q, qtan);
        stroke(color(#25892B));
        strokeWeight(3);
        line(oldpt.x,oldpt.y,oldpt.z,newpt.x,newpt.y,newpt.z);
        oldpt = newpt;
      }
    }
  }
  pt hermitePoint(float t, pt p0, vec tg0, pt p1, vec tg1){
    float a = 2*pow(t,3)-3*pow(t,2)+1;
    float b = pow(t,3)-2*pow(t,2)+t;
    float c = -2*pow(t,3)+3*pow(t,2);
    float d = pow(t,3)-pow(t,2);
    pt p = A(P(P(a,p0),V(b,tg0)),P(P(c,p1),V(d,tg1)));
    return p;
  }
}