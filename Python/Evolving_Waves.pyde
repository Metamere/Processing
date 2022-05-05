#By Metamere
#May 1 2022

def setup():
    frameRate(144)
    size(1600, 900)
    background(0)
    colorMode(HSB)

def draw():
    frame = frameCount # + 0  #offset to test behavior at various frame counts
    strokeWeight(1)
    stroke(frame/50 % 255, 255, 255, 15)
    h2 = .5*height
    rad = PI/180
    amp = (height*.5)*(.25 + .75*cos(frame*rad/250)**2)
    phase = frame/1000
    scan = .2
    freq = scan/width*frame*rad
    vibration = .1
    shift = (scan + vibration*sin(frame*rad/1000))*width
    x = 0
    while x <= width:
        x_step = 10 + shift*sin(freq*x)**2
        x2 = x + x_step
        y = amp*sin(.5*x*rad + phase) + h2
        y2 = amp*sin(.5*x2*rad + phase) + h2
        line(x,y,x2,y2)
        x = x2
