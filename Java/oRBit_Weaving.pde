//By Metamere
//May 19th, 2022
//for the weekly creative code challenge: theme = red, black, white

float r, r_max, r_factor, color_chance, transparent_chance;
float center_shift_x, center_shift_y, color_limit, alpha;
boolean rotate, save; 

color col;
String type, col_name;
int col_count, B_count; 
int image_number = 0;

String date = nf(month(), 2) + "-" + nf(day(), 2) + "-" + year() + "-" ;

boolean debug = false; // display debug text
boolean overlap = false; // don't redraw background if true, new set will be drawn on top of old set. Sometimes looks cool.
int image_run = 0; // save N images. Set to 0 to display a series of images until the run is manually stopped.
float display_time = 3; // when image_run = 0, it will display a new image every N seconds. Press enter to save the current frame.

int FPS = 60;  //plenty of chances to catch the save command keypress.
float wait_frames = FPS*display_time;

void setup(){
  fullScreen();
  pixelDensity(displayDensity());
  //size(1350,1350);
  frameRate(FPS);
  smooth(8);
  background(255);
  if (image_run > 1){debug = false;}
}

void draw(){

  if (image_run > 0 || image_number == 0 || frameCount % wait_frames == 0){
    image_number += 1;  

    if (image_run > 0 && image_number == image_run){noLoop();}
    
    if (overlap == false){background(color_select(random(0,height),"none"));}
    
    color_limit = random(.75,2);
    r_factor = random(1,2.5);
    int pow = int(random(1,4));
    
    if (random(1) < .75){rotate = true;}
    else{rotate = false;}
    
    if (random(1) < .3){
      center_shift_x = random(-width,width)*.2;
      center_shift_y = random(-height,height)*.2;
    }
    else{center_shift_x = 0; center_shift_y = 0;}
    
    float rotate_range = random(.1,10)/pow;
    float rotate_range_neg = -random(.1,10)/pow*int(random(0,2));
    int step_factor = int(random(1,3));
    float step_inc = random(.002,.006)/pow*step_factor;
    float step = pow(height*step_inc,pow)*10;
  
    translate(width*.5 + center_shift_x, height*.5 + center_shift_y);
    rotate(radians(int(random(0,5))*45));
    
    if (random(1) < .3){
      type = "stroke";
      noFill();
      transparent_chance = .35;
    }
    else{
      type = "fill";
      noStroke();
      transparent_chance = .25;
    }
    if (random(1) < transparent_chance){ alpha = 125;}
    else{alpha = 255;}
    
    r = 0;
    r_max = height*(random(.25,5)*pow + .5*(abs(center_shift_x)/width + abs(center_shift_y)/height));
  
    while (r < r_max){
  
      float r2 = height*.5 + r_factor*r;
      if (type == "stroke"){strokeWeight(.25*step);}
      if (rotate){rotate(radians(random(rotate_range_neg,rotate_range)));}
      col_count = 0;
      B_count = 0;
      color_select(r,type);
      ellipse(r,r,r2,r2);
      
      color_select(r,type);
      ellipse(-r,-r,r2,r2);
      
      color_select(r,type);
      ellipse(-r,r,r2,r2);
      
      color_select(r,type);
      ellipse(r,-r,r2,r2);
   
      r += step;
    }
    if (image_run > 0){ save("RWB_Metamere_" + date + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2)
                             + "_" + str(image_number) + ".png");}
      
    if(debug){
      print("type = " + type + '\n');
      if(rotate){
        print("rotate_range = " + rotate_range + '\n');
        print("rotate_range_neg = " + rotate_range_neg + '\n');
      }
      print("color_limit = " + str(color_limit) + '\n');
      print("r_factor = " + str(r_factor) + '\n');    
      print("r_max/height = " + str(r_max/height) + '\n');
      print("pow = " + str(pow) + '\n');
      print("step_factor = " + str(step_factor) + '\n');    
      print("1/step_inc = " + str(round(1/step_inc)) + '\n');
      print("step = " + str(round(step)) + '\n');
          
      print("render complete");
  
    }
  }
}

color color_select(float r, String type){
  color_chance = 1 - color_limit*r/r_factor/height - .15*sq(col_count);
  
  if ( random(1) < color_chance){
    col = color(255,0,0,alpha);
    if (r > 0) {col_count += 1;}
  }
  else if(random(1) < .5 - .08*sq(B_count)){
    col = color(0,alpha);
    B_count += 1;
  }
  else{ 
    col = color(255,alpha);
  }

  if(type == "fill"){fill(col);}
  else if (type == "stroke"){stroke(col);}
  return col;
}

void keyReleased(){
  if (image_run == 0 && key == ENTER){ 
    save("RWB_Metamere_" + date + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2)
                         + "_" + str(image_number) + ".png");
    print("saved frame # " + str(image_number) + '\n');
  }
}
