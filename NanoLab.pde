int currentParticles = 0;
int initialParticlesNum = 3000;
boolean useInitialParticles = true;
boolean useInstant = true;
boolean useShaders = false;
boolean useHandleCollisions = false;
float viscosity = 0.85;
float maxSpeed = 25;
float worldScale = 0.5;
boolean isDesktop = true;
int trueScreenWidth;
int trueScreenHeight;
int screenWidth;
int screenHeight;
int offsetX;
int offsetY;
float aspectRatio;
float zoom = 1;

Manager man;
Mouse mouse;
GUI gui;

void settings() {
  if (isDesktop) {
     trueScreenWidth = displayWidth;
     trueScreenHeight = displayHeight;
     fullScreen();
  } else {
     trueScreenWidth = screenWidth;
     trueScreenHeight = screenHeight;
     size(trueScreenWidth, trueScreenHeight);
  }
}

void setup() {
   man = new Manager();
   gui = new GUI(man);
   mouse = new Mouse();
   man.randomTypes();
   aspectRatio = trueScreenWidth / trueScreenHeight;
   offsetX = width / 2;
   offsetY = height / 2;
}

void draw() {
   man.update();
   mouse.update();
   gui.update();
}

void mouseWheel(MouseEvent event) {
   float e = event.getCount();
   if (e > 0) {
     zoom /= 1.1;
   } else {
     zoom *= 1.1;
   }
      
   println(zoom);
}

