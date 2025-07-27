import processing.opengl.*;
import java.awt.*;
import javax.swing.JFrame;
import com.jogamp.newt.opengl.GLWindow;

enum CollisionState {IN_SURFACE, IN_AIR, IN_DANGER}

Player player;
World world;
Robot mouseControl;
float camPitch = 0, camYaw = 0;
boolean pointerlockOn = false;
boolean[] keys = new boolean[256];

void writeHitbox(Hitbox hitbox) {
  byte[] originalData = loadBytes("levels/level1.dat");
  byte[] data = new byte[originalData.length+19];
  
  System.arraycopy(originalData, 0, data, 0, originalData.length);
  System.arraycopy(convert.intToBytes((int)hitbox.x, 3), 0, data, originalData.length, 3);
  System.arraycopy(convert.intToBytes((int)hitbox.y, 3), 0, data, originalData.length + 3, 3);
  System.arraycopy(convert.intToBytes((int)hitbox.z, 3), 0, data, originalData.length + 6, 3);
  System.arraycopy(convert.intToBytes((int)hitbox.w, 3), 0, data, originalData.length + 9, 3);
  System.arraycopy(convert.intToBytes((int)hitbox.h, 3), 0, data, originalData.length + 12, 3);
  System.arraycopy(convert.intToBytes((int)hitbox.d, 3), 0, data, originalData.length + 15, 3);
  System.arraycopy(convert.intToBytes(hitbox.isDanger ? 1 : 0, 1), 0, data, originalData.length + 18, 1);
  
  saveBytes("levels/level1.dat", data);
}

Hitbox[] getHitboxes(String filePath) {
  ArrayList<Hitbox> hitboxes = new ArrayList<>();
  byte[] hitboxContent = loadBytes(filePath);
  
  for (int j = 0; j < hitboxContent.length; j += 19) {
    Hitbox hitbox = new Hitbox(0, 0, 0, 0, 0, 0, false);
    for (int i = 0; i < 19; i += 3) {
      int index = i + j;
      
      int value;
      
      byte[] bytes;
      
      if (i == 18) {
        bytes = new byte[1];
        bytes[0] = hitboxContent[index];
        
        value = convert.bytesToInt(bytes, 1);
      } else {
        bytes = new byte[3];
        bytes[0] = hitboxContent[index];
        bytes[1] = hitboxContent[index+1];
        bytes[2] = hitboxContent[index+2];
        
        value = convert.bytesToInt(bytes, 3);
      }
      
      switch (i) {
        case 0:
         hitbox.x = value;
         break;
        case 3:
         hitbox.y = value;
         break;
        case 6:
         hitbox.z = value;
         break;
        case 9:
         hitbox.w = value;
         break;
        case 12:
         hitbox.h = value;
         break;
        case 15:
         hitbox.d = value;
         break;
        case 18:
         println(value);
         hitbox.isDanger = value == 0 ? false : true;
         break;
      }
    }
    
    hitboxes.add(hitbox);
  }
  
  Hitbox[] res = new Hitbox[hitboxes.size()];
  
  for (int i = 0; i < res.length; i++) {
    res[i] = hitboxes.get(i);
  }
  
  return res;
}

void setup() {
  size(1280, 720, OPENGL);

  try {
    mouseControl = new Robot();
  } catch (Throwable e) {
    e.printStackTrace();
  }
  
  pointerlock();
  
  saveBytes("levels/level1.dat", new byte[0]);
  writeHitbox(new Hitbox(0, 275, 0, 500, 500, 500, false));
  writeHitbox(new Hitbox(500, 275, 0, 500, 500, 500, true));
  
  world = new World(getHitboxes("levels/level1.dat"));
  
  player = new Player(0, -40, 0);
  player.world = world;
}

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}

void mousePressed() {
  noCursor();
  pointerlock();
  pointerlockOn = true;
}

void pointerlock() {
  GLWindow w = (GLWindow)surface.getNative();
  mouseControl.mouseMove(w.getX() + (width >> 1), w.getY() + (height >> 1));
}

void draw() {
  background(127, 225, 255);
  translate(0.5 * width, 0.5 * height, (0.5 * height) / tan(0.5 * THIRD_PI));
  
  if (pointerlockOn) {
    camYaw += (mouseX - (float)(width >> 1)) / width * PI;
    camPitch -= (mouseY - (float)(height >> 1)) / height * PI;
    pointerlock();
  }
  
  rotateX(camPitch);
  rotateY(camYaw);
  
  translate(-player.x, -player.y, -player.z);
  
  player.draw();
  if (!player.update()) {
    println("u died lol");
  }
  
  push();
    translate(0, 275, 0);
    fill(255);
    box(500);
  pop();
  
  for (Hitbox hitbox : world.hitboxes) {
    hitbox.draw();
  }
}
