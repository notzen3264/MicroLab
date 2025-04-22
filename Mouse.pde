class Mouse
{
   float radius;
   boolean selected;
   
   Mouse()
   {
      radius = 75;
      this.selected = false;
   }
   
   void update()
   { 
      if (mousePressed && selected && !gui.justPressed && mouseButton == LEFT)
      {
         noFill();
         stroke(255);
         strokeWeight(3);
         ellipse(mouseX, mouseY, radius*2 * zoom, radius*2 * zoom);
      }
   }
   
   boolean inMouse(Particle p)
   {
      return p.pos.dist(new PVector(mouseX, mouseY)) <= radius && mousePressed && selected;
   }
   
   PVector setPos()
   {
      return new PVector(mouseX - pmouseX, mouseY - pmouseY);
   }
}
