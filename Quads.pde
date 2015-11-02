void showAllQuads(ArrayList<pt> ac, ArrayList<pt> c1p, ArrayList<pt> c2p, boolean showInflation){
  int colFlag = 0;
  if (showInflation) {
    for(int i=0;i<ac.size()-1;i++){
      if(i%2==0) colFlag =0;
      else colFlag = 1;
      showQuad(ac.get(i), ac.get(i+1), c2p.get(i), V(ac.get(i),c1p.get(i)).norm(),color(0,102,0), colFlag);
    }
  }
  for(int i=0;i<c1tube.size()-1;i++){
    if(i%2==0) colFlag =0;
    else colFlag = 1;
    showTube(true,i,3,color(100,200,250),colFlag);
    showTube(false,i,3,color(255,153,153),colFlag);
  }
}

void showTube(boolean tube1, int ind, float r, color co, int colFlag){
 vec nor,pq;
 pt p,q;
 if(tube1) {
   p = c1tube.get(ind);
   q = c1tube.get(ind+1);
   nor = V(getTangent(curve1,((ind+1)*1.0)/c1tube.size()));
   nor = V(-nor.y,nor.x, nor.z);
 } else {
   p = c2tube.get(ind);
   q = c2tube.get(ind+1);
   nor = V(getTangent(curve2,((ind+1)*1.0)/c1tube.size()));
   nor = V(-nor.y,nor.x, nor.z);
 }
 
 pq = V(p,q);
 
 
 vec nornor = U(nor);
 pt pp[] = new pt[8];
 pt qp[] = new pt[8];
 pp[0] = P(p,V(r,nornor));
 qp[0] = P(q,V(r,nornor));
 for(int i=1;i<8;i++){
    vec ppv = R(V(p,pp[i-1]), PI/4, pq);
    pp[i] = P(p,ppv);
    vec qpv = R(V(q,qp[i-1]), PI/4, pq);
    qp[i] = P(q,qpv);
 }
 noStroke();
 color c1;
 color c2;
 boolean alt = true;
 if (colFlag == 1) {
   c1 = co;
   c2 = color(220,220,220);
 }
 else{
   c2 = co;
   c1 = color(220,220,220);
 }
 for(int i=0;i<7;i++){
   if (alt) fill(c1);
   else fill(c2);
   alt = !alt;
    
   beginShape(QUADS); 
   vertex(pp[i]); 
   vertex(qp[i]);
   vertex(qp[(i+1)%7]);
   vertex(pp[(i+1)%7]);
   endShape(CLOSE);
 }
}

void showQuad(pt p, pt q, pt m, float r, color co, int colFlag){
  vec pm = V(p,m);
  vec pq = V(p,q);
  vec nor =  N(pm,pq);
  vec nornor = U(nor);
  pt pp[] = new pt[8];
  pt qp[] = new pt[8];
  pp[0] = P(p,V(r,nornor));
  qp[0] = P(q,V(r,nornor));
  for(int i=1;i<8;i++){
     vec ppv = R(V(p,pp[i-1]), PI/4, pq);
     pp[i] = P(p,ppv);
     vec qpv = R(V(q,qp[i-1]), PI/4, pq);
     qp[i] = P(q,qpv);
  }
  noStroke();
  color c1;
  color c2;
  boolean alt = true;
  if (colFlag == 1) {
    c1 = co;
    c2 = color(220,220,220);
  }
  else{
    c2 = co;
    c1 = color(220,220,220);
  }
  for(int i=0;i<7;i++){
    if (alt) fill(c1);
    else fill(c2);
    alt = !alt;
    
    beginShape(QUADS); 
    vertex(pp[i]); 
    vertex(qp[i]);
    vertex(qp[(i+1)%7]);
    vertex(pp[(i+1)%7]);
    endShape(CLOSE);
  }
}