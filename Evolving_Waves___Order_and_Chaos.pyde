def setup():
    frameRate(100)
    size(1600, 900)
    background(0)
    colorMode(HSB)

def draw():  
    h2 = .5*height
    rad = PI/180
    amp = height/2 - 2
    strokeWeight(3)
    phase = frameCount/2
    stroke(phase/2 % 255, 255, 255, 20)
    shift2 = .333*width
    freq = .02/width*frameCount*rad
    x = 0
    while x <= width:
        x_step = 2+shift2*cos(freq*x)**2
        x2 = x + x_step
        y = amp*sin(.5*x*rad + phase) + h2
        y2 = amp*sin(.5*x2*rad + phase) + h2
        line(x,y,x2,y2)
        x = x2

    # if( frameCount % 10 == 0 ): 
        # saveFrame("EW_OC_########.png")
