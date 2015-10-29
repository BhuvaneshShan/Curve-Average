pt startPt,endPt;
pt[] curve1, curve2;

float ballSize = 5;

void init(){
  curve1 = new pt[7];
  curve2 = new pt[7];
  
  startPt = P(0,0,0);
  endPt = P(200, 200, 200);
}

void customizedInit(){
  curve1[0] = P(startPt);
  curve1[1] = P(30,50,40);
  curve1[2] = P(60,100,80);
  curve1[3] = P(100,140,120);
  curve1[4] = P(140,180,160);
  curve1[5] = P(180,160,200);
  curve1[6] = P(endPt);
  
  curve2[0] = P(startPt);
  curve2[1] = P(50,30,40);
  curve2[2] = P(100,80,80);
  curve2[3] = P(130,100,120);
  curve2[4] = P(185,150,160);
  curve2[5] = P(167,192,200);
  curve2[6] = P(endPt);
}



void showPoints(pt[] ptarray, color c, float size){
  for (int i = 0; i < ptarray.length; i++){
    show(ptarray[i], size, false, c);
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
  drawCubicBezier(curve1,3,color(128,0,128));
  drawCubicBezier(curve2,3,color(0,128,128));
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