class GUI {
   Manager man;
   Button menuButton;
   Button mouseToolButton;
   Button restartButton;
   Button newTypesButton;
   Button pauseButton;
   Button clearButton;
   Button shadersButton;
   Button collisionsButton;
   
   Integer selected;
   int frameIndex;
   boolean running;
   boolean justPressed;
   int fps;
   int lastTime;
   int time;
   boolean isSelected;
  
   float guiRadius;
   float guiDiameter;
   float space;
   int guiColour;
   float guiButtonWidth;
   float guiButtonHeight;
   
   GUI(Manager man) {
      this.selected = 0;
      frameIndex = 0;
      this.man = man;
      
      guiRadius = 17.5;
      guiDiameter = guiRadius * 2;
      space = guiDiameter + 10;
      guiColour = 100;
      guiButtonWidth = 200;
      guiButtonHeight = 45;
      
      running = true;
      justPressed = false;
      fps = 0;
      lastTime = millis();
      time = 0;
      currentParticles = 0;
      isSelected = false;
      
      menuButton = new Button(width - (100 + space - guiRadius), 1 * (space - guiRadius), 100, guiButtonHeight, "Menu", false, true);
      mouseToolButton = new Button(width - (guiButtonWidth + space - guiRadius), 3 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Mouse", false, false);
      restartButton = new Button(width - (guiButtonWidth + space - guiRadius), 5 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Restart Microenvironment", false, false);
      newTypesButton = new Button(width - (guiButtonWidth + space - guiRadius), 7 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "New Types", false, false);
      pauseButton = new Button(width - (guiButtonWidth + space - guiRadius), 9 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Pause", false, false);
      clearButton = new Button(width - (guiButtonWidth + space - guiRadius), 11 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Clear Microenvironment", false, false);
      shadersButton = new Button(width - (guiButtonWidth + space - guiRadius), 13 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Toggle Shaders", false, false);
      collisionsButton = new Button(width - (guiButtonWidth + space - guiRadius), 15 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Collisions (experimental!!)", false, false);
   }
   
   void update() {
      if (mousePressed && mouseButton == LEFT) {
         if (frameIndex % 2 == 0) {
            mouseDown();
         }
         frameIndex++;
      } else if (mousePressed && mouseButton == CENTER) {
         offsetX -= (mouseX - pmouseX) / zoom;
         offsetY -= (mouseY - pmouseY) / zoom;
      } else {
         frameIndex = 0;
         justPressed = false;
      }
      
      if (running) {
         int currentTime = millis();
         if (currentTime - lastTime > 1000) {
            fps = frameCount;
            frameCount = 0;
            lastTime = currentTime;
            time += 1;
         }
      }
      show();
   }
   
   void show() {
      for (int i = 0; i < man.types.size(); i++) {
         fill(man.types.get(i).c);
         noStroke();
         
         if (selected != null && selected == i && isSelected) {
            stroke(255);
            strokeWeight(3);
         }
         
         ellipse(space + i * space, space, guiDiameter, guiDiameter);
         noStroke();
      }
      
      menuButton.display();
      mouseToolButton.display();
      restartButton.display();
      newTypesButton.display();
      pauseButton.display();
      clearButton.display();
      shadersButton.display();
      collisionsButton.display();
      
      textSize(17.5);
      fill(255);
      textAlign(LEFT);
      text("Time Elapsed: " + time + "s", space - guiRadius, 100);
      text("FPS: " + fps, space - guiRadius, 130);
      text("Particles: " + currentParticles, space - guiRadius, 160);
      text("Types: " + man.types.size(), space - guiRadius, 190);
      text("Max Speed: " + maxSpeed, space - guiRadius, 220);
      text("'Viscosity': " + viscosity, space - guiRadius, 250);
      text("MicroLab v1.9.4 Desktop Supported", space - guiRadius, trueScreenHeight - 60);
      text("By @notzen3264 (Github)", trueScreenWidth - (space - guiRadius) - 200, trueScreenHeight - 60);
   }
   
   void mouseDown() {
      PVector pos = new PVector(mouseX, mouseY);
      for (int i = 0; i < man.types.size(); i++) {
         if (pos.dist(new PVector(space + i * space, space)) <= guiDiameter && !justPressed) {
            justPressed = true;
            this.isSelected = !this.isSelected;
            selected = i;
            mouse.selected = false;
            mouseToolButton.isSelected = false;
            return;
         }
      }
      
      if (clearButton.isMouseOver() && !justPressed) {
         justPressed = true;
         time = 0;
         man.particles.clear();
         currentParticles = 0;
         useInitialParticles = false;
         return;
      }
      
      if (pauseButton.isMouseOver() && !justPressed) {
         justPressed = true;
         running = !running;
         if(!running) {
            pauseButton.label = "Play";
         } else {
            pauseButton.label = "Pause";
         }
         return;
      }
      
      if (mouseToolButton.isMouseOver() && !justPressed) {
         justPressed = true;
         selected = null;
         mouse.selected = !mouse.selected;
         mouseToolButton.isSelected = !mouseToolButton.isSelected;
         return;
      }
      
      if (newTypesButton.isMouseOver() && !justPressed) {
         justPressed = true;
         time = 0;
         man.particles.clear();
         currentParticles = 0;
         man.types.clear();
         man.randomTypes();
         useInitialParticles = true;
         return;
      }
      
      if (restartButton.isMouseOver() && !justPressed) {
         justPressed = true;
         time = 0;
         man.particles.clear();
         currentParticles = 0;
         useInitialParticles = true;
      }
      
      if (shadersButton.isMouseOver() && !justPressed) {
         justPressed = true;
         useShaders = !useShaders;
         shadersButton.isSelected = !shadersButton.isSelected;
      }
      
      if (collisionsButton.isMouseOver() && !justPressed) {
         justPressed = true;
         useHandleCollisions = !useHandleCollisions;
         collisionsButton.isSelected = !collisionsButton.isSelected;
      }
      
      if (menuButton.isMouseOver() && !justPressed) {
         justPressed = true;
         mouseToolButton.isDisplay = !mouseToolButton.isDisplay;
         restartButton.isDisplay = !restartButton.isDisplay;
         newTypesButton.isDisplay = !newTypesButton.isDisplay;
         pauseButton.isDisplay = !pauseButton.isDisplay;
         clearButton.isDisplay = !clearButton.isDisplay;
         shadersButton.isDisplay = !shadersButton.isDisplay;
         collisionsButton.isDisplay = !collisionsButton.isDisplay;
         menuButton.isSelected = !menuButton.isSelected;
      }
      
      if (!mouse.selected && selected != null && !justPressed ) {
         man.addParticle(selected, mouseX, mouseY);
         currentParticles += 1;
      }
   }
}

class Button {
   float x, y, w, h;
   String label;
   boolean isSelected;
   boolean isDisplay;
   
   Button(float x, float y, float w, float h, String label, boolean isSelected, boolean isDisplay) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.label = label;
      this.isSelected = isSelected;
      this.isDisplay = isDisplay;
   }
   
   void display() {
      if (this.isDisplay) {
         // Using 100 directly to mimic guiColour functionality from GUI.
         fill(50);
         if (this.isSelected) {
            stroke(255);
            strokeWeight(3);
         } else {
            noStroke();
         }
         rect(x, y, w, h);
         fill(255);
         textSize(15);
         textAlign(CENTER, CENTER);
         text(label, x + w / 2, y + h / 2);
      }
   }
   
   boolean isMouseOver() {
      if (this.isDisplay) {
         return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
      } else {
         return false;
      }
   }
}
