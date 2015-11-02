void showAllQuads(ArrayList<pt> ac, ArrayList<pt> c1p, ArrayList<pt> c2p){
  int colFlag = 0;
  for(int i=0;i<ac.size()-1;i++){
    if(i%2==0) colFlag =0;
    else colFlag = 1;
    showQuad(c1p.get(i),c1p.get(i+1),ac.get(i),3,red,colFlag);
    showQuad(c2p.get(i),c2p.get(i+1),ac.get(i),3,blue,colFlag);
    showQuad(ac.get(i), ac.get(i+1), c2p.get(i), V(ac.get(i),c1p.get(i)).norm(),green, colFlag);
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