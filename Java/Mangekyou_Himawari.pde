// Mangekyou Himawari is Japanese for "kaleidoscope sunflower"
// By Metamere
// June 7, 2022

float time;

void setup(){
  size(1100,1100,P3D);
  pixelDensity(1);
  frameRate(144);
  noStroke();
  time = 250;//random(200,350);
}

void draw(){
  background(150);
  translate(width*.5, height*.5);
  float rad = 0;
  float ratio = 0;
  int i = 0;
  while (rad*2 < (height - 50)){
    ratio = 2*rad/height;
    
    pushMatrix();
    rad = i*(10/time);
    rotateZ(rad*100);
    ellipse(rad, 0, 5 + 10*ratio, 5 + 20*ratio);
    popMatrix();
    
    rotateZ(rad*.0015*sin(.00005*time*ratio));
    i += 1;
    if( i % 2 == 0) fill(0,80);
    else fill(255,0,0,80);
}
  time += .000008*time;
}

void keyPressed(){
    if (key == ENTER){
        loop();
        saveFrame("MH_" + str(round(time*100)/100) + "_F#######.png");
        print("Saved frame #" + str(frameCount) + "\n");
    }
}
