//by Metamere
//May 5th, 2022

int c1x, c1y, c2x, c2y;
int run_code;
int q1 = 1000, q2 = -1000;
int q_inc = 200;
int qf = 2;
color c;
boolean charge_cycle = true;
float x, y, dx, dy, dxn, dyn;
float d1, E1, E1x, E1y, d2, E2, E2x, E2y;
float EEx, EEy, EE, delta_x, delta_y, time, cycle_val;
float speed = .8;
ArrayList <Particle> particles = new ArrayList <Particle> ();

void setup() {
  colorMode(HSB,200,200,200,200);
  frameRate(144);
  size(1600, 1350, P2D);
  smooth(8);
  background(255,0,255,0);
  strokeWeight(1);
  c1x = int(width*.4);
  c2x = int(width*.6);
  c1y = int(height*.35);
  c2y = int(height*.65);
  run_code = int(random(1000000)); // used for images to reduce chance of images from successive runs having the same name
  while (particles.size () < 20000) { particles.add(new Particle()); }
}

void draw() {
  if (mousePressed){
    if(mouseButton == LEFT ){
      c1x = mouseX;
      c1y = mouseY;  
    }
    else if(mouseButton == RIGHT){
      c2x = mouseX;
      c2y = mouseY;
    }    
    if( mouseButton == CENTER ){
      c1x = mouseX;
      c1y = mouseY;
      c2x = width - mouseX;
      c2y = height - mouseY; 
    }  
  }
  
  time = frameCount*.0010;

  for (Particle p : particles) {
    p.run();
  }
}

class Particle {
  PVector loc;

  Particle() {
    loc = new PVector(random(width), random(height));
    c = color(255,25);
  }

  void run() {
    c = color(time*35 % 255,200,195,23);
    stroke(c);
    if (loc.x > width || loc.x < 0 || loc.y > height || loc.y < 0) {
      loc = new PVector(random(width), random(height));
    } else {
      loc.add(getDirection(loc));
      point(loc.x, loc.y);
    }
  }

  PVector getDirection(PVector p) {
    dx = p.x - c1x; 
    dy = p.y - c1y;
    d1 = sqrt(dx*dx + dy*dy);
    E1 = q1/(d1*d1);
    if (charge_cycle){
      cycle_val = sin(time);
      E1 *= cycle_val;
    }
    E1x = dx*E1/d1;
    E1y = dy*E1/d1;
    
    dxn = p.x - c2x;
    dyn = p.y - c2y;
    d2 = sqrt(dxn*dxn+dyn*dyn);
    E2 = q2/(d2*d2);
    if (charge_cycle){
      E2 *= cycle_val;
    }
    E2x = dxn*E2/d2;
    E2y = dyn*E2/d2;

    EEx = E1x + E2x;
    EEy = E1y + E2y;
    EE = sqrt(EEx*EEx + EEy*EEy);

    delta_x = speed*EEx/EE;
    delta_y = speed*EEy/EE;
    
    if ( (d1 < qf || d2 < qf) && random(99) < 1){
      delta_x = -1111; //send it out of bounds to force reseeding it
    }
    
    return new PVector(delta_x, delta_y);
  }
}

void keyPressed(){

    // q key switches charges from cycling mode to steady state mode.
    // q1 is controlled by arrow keys 
    // left to decrease charge, right to increase, 
    // down to set to negative (attract lines), up to set to positive (repel lines)
    // q2 is controlled by wasd
    // e sets q2 equal to q1
    // p to pause, Enter to save
    
    if (key == 'q'){
      if (charge_cycle){charge_cycle = false;}
      else{charge_cycle = true;}
    }
    else if(key == 'a'){q2 -= q_inc;}
    else if(key == 'd'){q2 += q_inc;}
    else if(key == 's'){q2 = -abs(q2);}
    else if(key == 'w'){q2 = abs(q2);}
    else if(key == 'e'){q2 = q1;}
    else if(keyCode == LEFT){q1 -= q_inc;}
    else if(keyCode == RIGHT){q1 += q_inc;}
    else if(keyCode == DOWN){q1 = -abs(q1);}
    else if(keyCode == UP){q1 = abs(q1);}
    
    else if (key == 'p'){
        looping = !looping;
        if (!looping){ print("Time stopped at frame " + str(frameCount) + ".\n"); }
        else{ print("Drawing resumed. \n"); }
    }
    if (key == ENTER){
        loop();
        saveFrame("EFP_" + str(run_code) + "_F########.png");
        print("Saved frame #" + str(frameCount) + "\n");
    }
}
