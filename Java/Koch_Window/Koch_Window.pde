// By Metamere
// May 26, 2022
// Weekly Creative Coding Challenge
// Topic: Stained Glass

// Modified from code taken from example 8.14 in: 
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

ArrayList<KochLine> lines;
int transmit, total, num;
float line_transmit = .75;
int background_transmit = 1;
int recursion_limit = 9;
float SW, scale, x1, x2, main_scale,left_bound,right_bound;
PVector centroid, a2, b2, c2;
float scale_factor;
boolean save;
  
void setup() {
  fullScreen();
  //size(4800, 2700);
  smooth();
  colorMode(HSB);
  centroid = new PVector(0,0);
  total = 2;
  main_scale = .815; // for 16:9 monitor, .815 is a good fit vertically at the max recursion level
  scale_factor = .035;
  SW = 10;
}

void draw() {

  background(background_transmit*255);
  right_bound = width*main_scale;
  left_bound = width*(1-main_scale);
  for (int set = 0; set < 2; set++) {
    for (int n = 1; n < total; n++) {
      lines = new ArrayList<KochLine>();
      if (set == 0){
        x1 = left_bound;
        x2 = right_bound;
      }else{
        x1 = right_bound;
        x2 = left_bound;
      }  
      PVector start = new PVector(x1, height*.5);
      PVector end   = new PVector(x2, height*.5);
      lines.add(new KochLine(start, end));
      for (int i = 0; i < n; i++) {
        generate(n);
      }
  
      for (KochLine l : lines) {
        l.display();
      }
    }
  }
  if (save) save("Koch_Window.png");
  save = false;
  
  noLoop();
}

void generate(int level) {
  ArrayList next = new ArrayList<KochLine>();
  for (KochLine l : lines) {

    PVector a = l.kochA();                 
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();
    
    float ratio = (level+0.0)/total;
    //print(ratio + " ");
    noStroke();
    scale = scale_factor*level;
    transmit = int(100*(1-ratio));
    fill(0+random(10),255,255,transmit);    
    make_triangle(a, b, c, scale);
    fill(150+random(-5,5),255,255,transmit);
    make_triangle(b, c, d, scale);
    fill(25+random(-5,5),255,255,transmit);
    make_triangle(c, d, e, scale);

    stroke(0,0,5*level,line_transmit*(255-30*level));
    strokeWeight(SW*(1-ratio));
    next.add(new KochLine(a, b));
    next.add(new KochLine(a, c));
    next.add(new KochLine(b, c));
    next.add(new KochLine(b, d));
    next.add(new KochLine(c, d));
    next.add(new KochLine(c, e));
    next.add(new KochLine(d, e));

  }
  lines = next;
}

void make_triangle(PVector a, PVector b, PVector c, float scale) {
  
  centroid.set((a.x + b.x + c.x )/3, (a.y + b.y + c.y)/3);

  a2 = PVector.lerp(a,centroid,scale);
  b2 = PVector.lerp(b,centroid,scale);
  c2 = PVector.lerp(c,centroid,scale);
  triangle(a2.x, a2.y, b2.x, b2.y, c2.x, c2.y);
}

void keyPressed(){
  if (keyCode == LEFT){      scale_factor -= .005;}
  else if(keyCode == RIGHT){ scale_factor += .005;}
  if (keyCode == DOWN){    main_scale = max(.815+min(scale_factor,0), main_scale - .05);}
  else if (keyCode == UP){ main_scale = min(3, main_scale + .05);}
  else if( key == 'b'){ background_transmit = 1 - background_transmit;}
  else if( key == 'k'){ line_transmit = max(0,line_transmit - .025);}
  else if( key == 'l'){ line_transmit = min(1,line_transmit + .025);}
  else if(key == 'i'){ SW = max(.5,SW - 1);}
  else if(key == 'o'){ SW += 1;}
  else if(key == 's'){ save = true;} 
  num = int(key)-48;
  if( num <= 9 && num >= 2 ){  
    total = num;
    print("recursion level = " + str(total) + "\n");
  }
  loop();
}
