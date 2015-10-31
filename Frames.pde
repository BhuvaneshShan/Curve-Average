pt startPt = P(0,0,0);
pt endPt = P(200, 200, 200);
pt[] curve1 = {P(startPt), P(30,50,40), P(60,100,80), P(100,140,120), P(140,180,160), P(180,160,200), P(endPt)};
pt[] curve2 = {P(startPt), P(50,30,40), P(100,80,80), P(130,100,120), P(185,150,160), P(167,192,200), P(endPt)};
int NUMCTRLPTS = 7;

float ballSize = 5;

int pickedCtrl = -1;
int pickedCurve = -1;

void init(){
  

}

void customizedInit(){
  
  
  
}



void showPoints(pt[] ptarray, color c, float size){
  for (int i = 0; i < ptarray.length; i++){
    show(ptarray[i], size, false, c);
  }
}

void draw7Bezier(pt[] controls, float lineWidth, color c){
  pt previousPt = P(controls[0]);
  for (int t=0; t<=100; t++){
    pt nextPt = P(bezierCurve(controls[0], controls[1], controls[2], controls[3],controls[4],controls[5],controls[6], (float)t/100.0));
    stroke(c,255);
    strokeWeight(lineWidth);
    line(previousPt.x, previousPt.y, previousPt.z, nextPt.x, nextPt.y, nextPt.z);
    previousPt = P(nextPt);
  }
}

void drawCubicBezier(pt[] controls, float lineWidth, color c){
  pt previousPt = controls[0];
  pt nextPt;
  for (int i = 0; i < controls.length - 3; i+=3){
    for (int t = 0; t <= 100; t++){
      nextPt = P(bezierCurve(controls[i], controls[i+1], controls[i+2], controls[i+3], (float)t/100.0));
      //println("nextPt: ", nextPt.x, nextPt.y, nextPt.z);
      stroke(c,255);
      strokeWeight(lineWidth);
      line(previousPt.x, previousPt.y, previousPt.z, nextPt.x, nextPt.y, nextPt.z);
      previousPt = P(nextPt);
    }
  }
}

void Interpolate(){
  //show(startPt, 10);
  //show(endPt, 10);
  showPoints(curve1, color(128,0,128), ballSize);
  showPoints(curve2, color(0,128,128), ballSize);
  draw7Bezier(curve1, 3, color(128, 0, 128));
  draw7Bezier(curve2, 3, color(0, 128, 128));  
  
  //To move control points of the curves.
  if(mousePressed&&!keyPressed){
     pickedCtrl = -1;
     pickedCurve = -1;
     pt pickedPt = pick( mouseX, mouseY);  
     print("Picked position:"+Of.x+","+Of.y+","+Of.z);
     for (int i=0; i<NUMCTRLPTS; i++){
       if(isPicked(pickedPt, curve1[i], ballSize)){
         pickedCurve = 1;
         pickedCtrl = i;
       }
       if(isPicked(pickedPt, curve2[i], ballSize)){
         pickedCurve = 2;
         pickedCtrl = i;
       }
     }
     
     //for(int i=0 ; i<2; i++){
     //  if(isPicked(pickedPt,frame[i])){
     //    pickedFrame = i;
     //  }
     //}
     //if(isPickedForRotating(pickedPt,frame[0],initialBallSize)){
     //    pickedFrame = 0;
     //  }
     // if(isPickedForRotating(pickedPt,frame[1],finalBallSize)){
     //    pickedFrame = 1;
     //  }
  } 
}

void show(pt p, float side, boolean cube, color c)
{
  //boolean cube = false;
  if(cube){
    stroke(c);
    pushMatrix(); translate(p.x,p.y,p.z); box(side); popMatrix();
    }
  else{stroke(c); pushMatrix(); translate(p.x,p.y,p.z); sphere(side); popMatrix();}
}

vec AxisAngleVec(FR f){
  return new vec(f.K.y - f.J.z,f.I.z-f.K.x,f.J.x -f.I.y);
}
float trace(FR f){
  return f.I.x+f.J.y+f.K.z;
}

boolean isPicked(pt of,FR fr){
  if(fr.O.x + 5 > of.x && fr.O.x-5 < of.x)
    if(fr.O.y + 5 > of.y && fr.O.y-5 < of.y)
      if(fr.O.z + 5 > of.z && fr.O.z-5 < of.z)
        return true;
  return false;
}

boolean isPicked(pt of, pt ctrl, float threshold){
  if(ctrl.x + threshold > of.x && ctrl.x-threshold < of.x)
    if(ctrl.y + threshold > of.y && ctrl.y-threshold < of.y)
      if(ctrl.z + threshold > of.z && ctrl.z-threshold < of.z)
        return true;
  return false;
}

boolean isPickedForRotating(pt of, FR fr, float size){
  float s = size * 4;
  pt i = P(fr.O);
  i = i.add(s,fr.I);
  pt j  = P(fr.O);
  j = j.add(s,fr.J);
  pt k = P(fr.O);
  k = k.add(s,fr.K);
  if(i.x + 5 > of.x && i.x-5 < of.x)
    if(i.y + 5 > of.y && i.y-5 < of.y)
      if(i.z + 5 > of.z && i.z-5 < of.z)
        return true;
  if(j.x + 5 > of.x && j.x-5 < of.x)
    if(j.y + 5 > of.y && j.y-5 < of.y)
      if(j.z + 5 > of.z && j.z-5 < of.z)
        return true;
  if(k.x + 5 > of.x && k.x-5 < of.x)
    if(k.y +5 > of.y && k.y-5 < of.y)
      if(k.z + 5 > of.z && k.z-5 < of.z)
        return true;
   return false;
}

class FR { 
  pt O; vec I; vec J; vec K;
  FR () {O=P(); I=V(1,0,0); J=V(0,1,0); K=V(0,0,1);}
  FR(vec II, vec JJ, vec KK, pt OO) {I=V(II); J=V(JJ); K = V(KK); O=P(OO);}
  void set (vec II, vec JJ, vec KK, pt OO) {I=V(II); J=V(JJ); K = V(KK); O=P(OO);}
  
  void movePicked(vec V) { O.add(V);}
  void rotatePicked(float v){ 
    float angle = 0.05*v;
    println("\nAngle to rotate:"+angle);
    I = R(this.I,angle,this.K);
    J = R(this.J,angle,this.K);
    //K = R(this.K,angle,this.J);
  }
  void rotatePickedZ(float v){
    float angle = 0.05*v;
    println("\nAngle to rotate:"+angle);
    K = R(this.K,angle,this.I);
    //I = R(this.I,angle,this.K);
    J = R(this.J,angle,this.I);
    
  }

}
  
class Ball{
  pt pos;
  float radius = 5;
  Ball(){
    pos = new pt();
  }
  Ball(float x, float y, float z){
    pos = new pt(x,y,z);
  }
  Ball(FR fr){
    pos = new pt(fr.O.x,fr.O.y,fr.O.z);
  }
  public void show(){
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    sphere(radius);
    popMatrix();
  }
  public void setXYZ(float x, float y, float z){
    pos = pos.setTo(x,y,z);
  }
  public void setPt(pt loc){
    pos = pos.setTo(loc);
  }
  public void setValues(FR fr){
    pos = pos.setTo(fr.O);
  }
  public void setRadius(float rad){
    radius = rad;
  }
}

class Sphere{
  float x,y,z;
  float radius;
  Sphere(float x, float y, float z, float radius){
    this.x = x;
    this.y = y;
    this.z = z;
    this.radius = radius;
  }
  public void show(){
    pushMatrix();
    translate(x,y,z);
    sphere(radius);
    popMatrix();
  }
}