// By Metamere
// May 13th (a Friday) 2022

float x_map, theta, xr, xr2, yr, yr2;
float phase, spread, ratio, shift, shift_sq, stroke_weight;
float hue, sat, alpha;
int w2, h2, cX, cY, cX_target, cY_target, recursion_count;
int circle_stroke_loc = 0;
int circle_stroke_range = 0;
double interval = 0.618;
int angle_limit = 720;
int angle_limit2 = 6;
boolean x_ray_mode;
boolean circle_stroke = true;
boolean spiral_line = true;
String date;

void setup() {
  colorMode(HSB);
  frameRate(60);
  size(1200, 1200, P3D);
  w2 = width/2;
  h2 = height/2;
  cX = w2;
  cY = int(height*.2);
  cX_target = cX;
  cY_target = cY;
  background(255);
  date = nf(month(), 2) + "-" + nf(day(), 2) + "-" + year() + "-" ;
}
void draw() {
  if (spiral_line == true){angle_limit2 = min(angle_limit*3,angle_limit2+1);}
  if( mouseButton == LEFT){
    if(mouseX < 30){ cX_target = 0; } 
    else{ cX_target = mouseX;}
    if(mouseY < 0){ cY_target = 0; } 
    else{ cY_target = mouseY;}
  }
  if (cX != cX_target){cX = int(lerp(cX,cX_target,.01));} //make smooth transitions.
  if (cY != cY_target){cY = int(lerp(cY,cY_target,.01));}
  if (x_ray_mode == true) {background(255);}
  spread = map(cY, 0, height, 0, width*.25);
  x_map = map(cX, 0, width, 0, 20);
  phase = -frameCount*.15;
  theta = 0; xr2 = 0; yr2 = 0;
  while (theta < angle_limit*3 ){

    ratio = theta/angle_limit;
    shift = sin(2*PI*ratio - phase*.1);
    shift_sq = pow(shift,2);
    xr = .1 + theta*.015*spread*cos(radians(theta + phase));
    yr = .1 + theta*.015*spread*sin(radians(theta + phase));
    stroke_weight = ratio*(.5*x_map + 5*shift*x_map); 
    if (theta < angle_limit){
      recursion_count = 0;
      drawcircle(w2+xr, h2+yr, ratio*width*4, 2, interval, 25*(1-ratio), 10*(1-ratio));
    }
    if (spiral_line == true && theta > 6 && theta < angle_limit2){
      strokeWeight(stroke_weight);
      stroke(hue,sat*.5,50+100*shift_sq-50*shift,15 + 50*shift_sq);
      line(w2+xr,h2+yr,w2+xr2,h2+yr2);
    }
    xr2 = xr;
    yr2 = yr;
    theta += 6;
  }
}

void drawcircle(float x, float y, float size, float size_limit, double interval, float alpha_max, float alpha_min) {
  hue = map(size, 10, width*.75, 200.0, 0.0);
  sat = map(size, 0, width*.75, 255.0, 200.0);
  alpha = map(size, 10, width*.75, alpha_max, alpha_min);
  color color1 = color(hue, sat, 200, alpha);
  fill(color1);
  if (circle_stroke == true &&
       ((recursion_count <= (circle_stroke_loc + circle_stroke_range) && 
       recursion_count >= (circle_stroke_loc - circle_stroke_range)))
  ){
    strokeWeight(pow(-1+.25*x_map + recursion_count + circle_stroke_loc*x_map*.25,.8));
    stroke(hue,sat,100,alpha*2);
  }
  else{noStroke();}
  ellipse(x, y, size, size);
  recursion_count += 1;
  if (size >= size_limit) {
    size*= interval;
    drawcircle(x, y, size, size_limit, interval, alpha_max, alpha_min);
  }
}

void keyPressed() {
  // space key
  if(key == ' '){
    circle_stroke = !circle_stroke;
    print("circle_stroke = " + str(circle_stroke) + '\n');
    if (circle_stroke == true){circle_stroke_loc = 0;circle_stroke_range = 0;}
  }
  else if(key == 's'){
    spiral_line = !spiral_line;
    print("spiral_line = " + str(spiral_line) + '\n');
    if (spiral_line == false){angle_limit2 = 0;}
  }
  else if(keyCode == LEFT){
    circle_stroke_loc = max(0,circle_stroke_loc - 1); 
    print("circle_stroke_loc = " + str(circle_stroke_loc) + '\n');}
  else if(keyCode == RIGHT){
    circle_stroke_loc = min(100,circle_stroke_loc + 1); 
    print("circle_stroke_loc = " + str(circle_stroke_loc) + '\n');}
  else if(keyCode == DOWN){
    circle_stroke_range = max(0,circle_stroke_range - 1);
    print("circle_stroke_range = " + str(circle_stroke_range) + '\n');}
  else if(keyCode == UP){
    circle_stroke_range = min(115,circle_stroke_range + 1);
    print("circle_stroke_range = " + str(circle_stroke_range) + '\n');}
}

void mousePressed() {
  if(mouseButton == RIGHT){x_ray_mode = !x_ray_mode;}
  else if(mouseButton == CENTER){
    saveFrame("Snail_Heart_Galaxy_" + date + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ".jpg");
  }
} 
