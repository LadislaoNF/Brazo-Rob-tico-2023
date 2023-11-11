//Alpern's: 192.168.20.5
//The local IP used by "Bedmen" is 192.168.20.224
//Subnet mask: 255.255.255.0
//Gateway IP: 192.168.20.254
//DNS 1: 192.168.20.254
//DNS 2: 0.0.0.0


//Wait, do i have to use ekoparty's ip?
//I mean, the computer should be connected to a wifi.
//but i can just make it so that the computer connects to my phone
//and the esp too
//that should solve the issue and provide a safe, fast, and accesible solution.

//------------------------------------------------LIBRARIES--------------------------------------------
import hypermedia.net.*;
import SimpleOpenNI.*;
import processing.serial.*;
Serial myPort;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
SimpleOpenNI kinect;

//------------------------------------------------LIBRARIES--------------------------------------------
//------------------------------------------------UDP SPECIFICS (DO NOT CHANGE)--------------------------------------------
public class JPGEncoder {
  
  byte[] encode(PImage img) throws IOException {
    ByteArrayOutputStream imgbaso = new ByteArrayOutputStream();
    ImageIO.write((BufferedImage) img.getNative(), "jpg", imgbaso);

    return imgbaso.toByteArray();
  }

  PImage decode(byte[] imgbytes) throws IOException {
    BufferedImage imgbuf = ImageIO.read(new ByteArrayInputStream(imgbytes));
    PImage img = new PImage(imgbuf.getWidth(), imgbuf.getHeight(), RGB);
    imgbuf.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    img.updatePixels();

    return img; 
  }

}
 UDP udp;  // define the UDP object
  JPGEncoder jpg;
PImage test;
PImage copia;
int proc=0;
 byte[] buf = new byte[1];
 
String ip       = "192.168.20.5";  // the remote IP address "192.168.80.156" alepern's    //this will be the router's ip; in this case, ekoparty's ip adress. you will use the esp32 to get it.
 int port        = 2222;    // the destination port  //this is defined by me
 
int dato0;
int dato1;
int dato2;
int dato3;
int dato4;
int dato5;
String enviar;
 
//------------------------------------------------UDP SPECIFICS (DO NOT CHANGE)--------------------------------------------
//------------------------------------------------- VARIABLES ---------------------------------------------

//Vectors used to calculate the center of the mass
PVector com = new PVector();
PVector com2d = new PVector();

//Up
float LeftshoulderAngle = 0;
float LeftelbowAngle = 0;
float RightshoulderAngle = 0;
float RightelbowAngle = 0;

//Legs
float RightLegAngle = 0;
float LeftLegAngle = 0;

//Timer variables
float a = 0;
float[] information;
         //float[] information = {1,2};
//information[0]=90; to establish information, use this.
String RightShoulder="FUCK";
String RightElbow="FUCK";
String LeftShoulder="FUCK";
String LeftElbow="FUCK";
String RightLeg="FUCK";
String LeftLeg="FUCK";
//  RightshoulderAngle is a Float
String sent;
int lastshoulderangleright;
int lastshoulderangleleft;
int angleservo=80;
int speed=255;
int direct=0;

// int(X) es para float
// X.toInt() es para string

//------------------------------------------------- VARIABLES ---------------------------------------------
//------------------------------------------------SETUP--------------------------------------------
 void setup() {
   
   //String portName = "COM15";    //WRITE THE PORT

        size(640, 480);
        kinect = new SimpleOpenNI(this);
        kinect.enableDepth();
        //kinect.enableIR(); 
        kinect.enableUser();// because of the version this change
        //size(640, 480);
        fill(255, 0, 0);
        //size(kinect.depthWidth()+kinect.irWidth(), kinect.depthHeight());
        kinect.setMirror(false);
//        myPort = new Serial(this, portName, 115200);  // USE // TO DISABLE ARDUINO FUNCTIONS
  
 //fullScreen(); 
 //orientation(LANDSCAPE);
 buf[0] =1;
 udp = new UDP( this, 2222 );  // create a new datagram connection on port 6000
 //udp.log( true );     // <-- printout the connection activity
 udp.listen( false );   // and wait for incoming message
 jpg = new JPGEncoder();
 size (640,480);
   //surface.setResizable(true);
   
 test =createImage(640,480,RGB);
 copia =createImage(160,120,RGB);
 }
//------------------------------------------------SETUP--------------------------------------------
//------------------------------------------------DRAW--------------------------------------------
 void draw()
 {
   image(test,0,0);
   //copia.resize(width,height);
   //copia.copy(test,0,0,160,120,0,0,width,height);
 
         kinect.update();
        //image(kinect.depthImage(), 0, 0);
        //image(kinect.irImage(),kinect.depthWidth(),0);
        image(kinect.userImage(),0,0);
        IntVector userList = new IntVector();
        kinect.getUsers(userList);
        if (userList.size() > 0) {
                int userId = userList.get(0);
                //If we detect one user we have to draw it
                if( kinect.isTrackingSkeleton(userId)) {
                        //DrawSkeleton
                        drawSkeleton(userId);
                        //drawUpAngles
                        ArmsAngle(userId);
                        //Draw the user Mass
                        MassUser(userId);
                        //AngleLeg
                        LegsAngle(userId);
                }
        }
        
 }
//------------------------------------------------DRAW--------------------------------------------
//------------------------------------------------KEY PRESSED--------------------------------------------
 void keyPressed() { 

// udp.send("Hello World", ip, port );   // the message to send ------------------------------------------------------------------------------------------------------------------
 //mandar datos por un array de chars
 //doesn't have to be in keypressed, you can do it anywhere.

 }
//------------------------------------------------KEY PRESSED--------------------------------------------
//------------------------------------------------KINECT BODY DETECTOR AND WRITING--------------------------------------------
void drawSkeleton(int userId) {
        stroke(0);
        strokeWeight(5);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
        noStroke();
        fill(255,0,0);
        drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
        drawJoint(userId, SimpleOpenNI.SKEL_NECK);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
        drawJoint(userId, SimpleOpenNI.SKEL_NECK);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);

 
}

void drawJoint(int userId, int jointID) {
        PVector joint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID,
                                                           joint);
        if(confidence < 0.5) {
                return;
        }
        PVector convertedJoint = new PVector();
        kinect.convertRealWorldToProjective(joint, convertedJoint);
        ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}
//Generate the angle
float angleOf(PVector one, PVector two, PVector axis) {
        PVector limb = PVector.sub(two, one);
        return degrees(PVector.angleBetween(limb, axis));
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID) {
        println("Start skeleton tracking");
        kinect.startTrackingSkeleton(userID);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
        println("onLostUser - userId: " + userId);
}

void MassUser(int userId) {
        if(kinect.getCoM(userId,com)) {
                kinect.convertRealWorldToProjective(com,com2d);
                stroke(100,255,240);
                strokeWeight(3);
                beginShape(LINES);
                vertex(com2d.x,com2d.y - 5);
                vertex(com2d.x,com2d.y + 5);
                vertex(com2d.x - 5,com2d.y);
                vertex(com2d.x + 5,com2d.y);
                endShape();
                fill(0,255,100);
                text(Integer.toString(userId),com2d.x,com2d.y);
        }
}

public void ArmsAngle(int userId){
        // get the positions of the three joints of our right arm
        PVector rightHand = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
        PVector rightElbow = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
        PVector rightShoulder = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
        // we need right hip to orient the shoulder angle
        PVector rightHip = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);
        // get the positions of the three joints of our left arm
        PVector leftHand = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
        PVector leftElbow = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,leftElbow);
        PVector leftShoulder = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder);
        // we need left hip to orient the shoulder angle
        PVector leftHip = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHip);
        // reduce our joint vectors to two dimensions for right side
        PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
        PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
        PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
        PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
        // calculate the axes against which we want to measure our angles
        PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
        PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);
        // reduce our joint vectors to two dimensions for left side
        PVector leftHand2D = new PVector(leftHand.x, leftHand.y);
        PVector leftElbow2D = new PVector(leftElbow.x, leftElbow.y);
        PVector leftShoulder2D = new PVector(leftShoulder.x,leftShoulder.y);
        PVector leftHip2D = new PVector(leftHip.x, leftHip.y);
        // calculate the axes against which we want to measure our angles
        PVector torsoLOrientation = PVector.sub(leftShoulder2D, leftHip2D);
        PVector upperArmLOrientation = PVector.sub(leftElbow2D, leftShoulder2D);
        // calculate the angles between our joints for rightside
        RightshoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
        RightelbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
        // show the angles on the screen for debugging
        fill(255,0,0);
        scale(1);
        text("Right shoulder: " + int(RightshoulderAngle) + "\n" + " Right elbow: " + int(RightelbowAngle), 20, 20);
        
    //    data1=RightshoulderAngle;
   //     data2=RightelbowAngle;
  /*      
        if(RightshoulderAngle<10)
        {         
          RightShoulder="00"+str(RightshoulderAngle);      
        }
        else if(RightshoulderAngle>9&&RightshoulderAngle<100)
        {
          RightShoulder="0"+str(RightshoulderAngle);
        }
        else
        {
          RightShoulder=str(RightshoulderAngle);
        }
        
        
        if(RightelbowAngle<10)
        {         
          RightElbow="00"+str(RightelbowAngle);      
        }
        else if(RightelbowAngle>9&&RightelbowAngle<100)
        {
          RightElbow="0"+str(RightelbowAngle);
        }
        else
        {
          RightElbow=str(RightelbowAngle);
        }
        
        
        if(LeftelbowAngle<10)
        {         
          LeftElbow="00"+str(LeftelbowAngle);      
        }
        else if(LeftelbowAngle>9&&LeftelbowAngle<100)
        {
          LeftElbow="0"+str(LeftelbowAngle);
        }
        else
        {
          LeftElbow=str(LeftelbowAngle);
        }
  */      
        
        if(LeftshoulderAngle<10)
        {         
          LeftShoulder="00"+str(LeftshoulderAngle);      
        }
        else if(LeftshoulderAngle>9&&LeftshoulderAngle<100)
        {
          LeftShoulder="0"+str(LeftshoulderAngle);
        }
        else
        {
          LeftElbow=str(LeftshoulderAngle);
        }
        
    /*    
        if(RightLegAngle<10)
        {         
          RightElbow="00"+str(RightelbowAngle);      
        }
        else if(RightelbowAngle>9&&RightelbowAngle<100)
        {
          RightElbow="0"+str(RightelbowAngle);
        }
        else
        {
          RightElbow=str(RightelbowAngle);
        }

*/
// sent=RightShoulder + "," + RightElbow + "," + LeftShoulder + "," + LeftElbow+ "," + RightLeg+ "," + LeftLeg;       
 //sent=RightElbow;
        
        //float[] information = {1,2};
      //information[0]=RightshoulderAngle;  //this is the line of code that fucked everything up.
      //information[1]=RightelbowAngle;    //I think the problem is the change between types of info? I mean str, float, that stuff. It only fucks up when doing that!
        //udp.send(information, ip, port );   // the message to send ------------------------------------------------------------------------------------------------------------------
    //this means: value, ip, and port
        //udp.send(sent, ip, port);   // the message to send ------------------------------------------------------------------------------------------------------------------
  //i got one question though. he wants me to send info like "620, 923". But that would require extra steps! No, dumbass, you just gotta print 1, 2. And THEN separate.
  //But why? i can just send it without 
  // THIS IS WHAT YOU ARE LOOKING FOR --------------------------------------------------------------------------------------------------------------------------------------
        //   I can do string -> int but i can't int -> string
        
        // calculate the angles between our joints for leftside
        LeftshoulderAngle = angleOf(leftElbow2D, leftShoulder2D, torsoLOrientation);
        LeftelbowAngle = angleOf(leftHand2D,leftElbow2D,upperArmLOrientation);
        
        if(lastshoulderangleleft!=int(LeftshoulderAngle)){
          if(int(LeftshoulderAngle) >110){
            angleservo=110;
            senddata();
          }
          else if(int(LeftshoulderAngle) <50){
            angleservo=50;
            senddata();
          }else{
            angleservo=int(LeftshoulderAngle);
            senddata();
          }
          lastshoulderangleleft=int(LeftshoulderAngle);
        }
        else{
          lastshoulderangleleft=int(LeftshoulderAngle);
        }
        
        if(lastshoulderangleright!=int(RightshoulderAngle)){
          if(int(RightshoulderAngle) >100){
            //angleservo=110;
            direct = 1;
            senddata();
          }
          else if(int(LeftshoulderAngle) <80){
            //angleservo=50;
            direct=2;
            senddata();
          }else{
            //angleservo=int(LeftshoulderAngle);
            direct=0;
            senddata();
          }
          lastshoulderangleright=int(RightshoulderAngle);
        }
        else{
          lastshoulderangleright=int(RightshoulderAngle);
        }       


        // show the angles on the screen for debugging
        fill(255,0,0);
        scale(1);
        text("Left shoulder: " + int(LeftshoulderAngle) + "\n" + " Left elbow: " + int(LeftelbowAngle), 20, 55);
}
void senddata(){
   sent=str(int(RightelbowAngle));//+"," +str(speed)+"," +str(direct)+"," +"0";//  sent=str(angleservo);
  udp.send(sent, ip, port);  //----------------------------------------------------------------------------------------------------------------------------------------------------
}
void LegsAngle(int userId) {
        // get the positions of the three joints of our right leg
        PVector rightFoot = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,rightFoot);
        PVector rightKnee = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,rightKnee);
        PVector rightHipL = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHipL);
        // reduce our joint vectors to two dimensions for right side
        PVector rightFoot2D = new PVector(rightFoot.x, rightFoot.y);
        PVector rightKnee2D = new PVector(rightKnee.x, rightKnee.y);
        PVector rightHip2DLeg = new PVector(rightHipL.x,rightHipL.y);
        // calculate the axes against which we want to measure our angles
        PVector RightLegOrientation = PVector.sub(rightKnee2D, rightHip2DLeg);
        // calculate the angles between our joints for rightside
        RightLegAngle = angleOf(rightFoot2D,rightKnee2D,RightLegOrientation);
        fill(255,0,0);
        scale(1);
        text("Right Knee: " + int(RightLegAngle), 500, 20);
        // get the positions of the three joints of our left leg
        PVector leftFoot = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,leftFoot);
        PVector leftKnee = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,leftKnee);
        PVector leftHipL = new PVector();
        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHipL);
        // reduce our joint vectors to two dimensions for left side
        PVector leftFoot2D = new PVector(leftFoot.x, leftFoot.y);
        PVector leftKnee2D = new PVector(leftKnee.x, leftKnee.y);
        PVector leftHip2DLeg = new PVector(leftHipL.x,leftHipL.y);
        // calculate the axes against which we want to measure our angles
        PVector LeftLegOrientation = PVector.sub(leftKnee2D, leftHip2DLeg);
        // calculate the angles between our joints for left side
        LeftLegAngle = angleOf(leftFoot2D,leftKnee2D,LeftLegOrientation);
        // show the angles on the screen for debugging
        fill(255,0,0);
        scale(1);
        text("Leftt Knee: " + int(LeftLegAngle), 500, 55);
}
//------------------------------------------------KINECT BODY DETECTOR AND WRITING--------------------------------------------
//------------------------------------------------UDP RECIEVER--------------------------------------------
 void receive( byte[] data ) {       // <-- default handler
 //void receive( byte[] data, String ip, int port ) {  // <-- extended handler
/*test.loadPixels();
 for(int i=(data[960])*(data.length-1); i < (data[960]+1)*(data.length-1); i++){
   
   test.pixels[i] = color(data[i-(data[960])*(data.length-1)]);
 }
 //println(data[240]);
 test.updatePixels();*/
     if(data.length<1000){
       buf = expand(buf,buf.length + data.length);
       arrayCopy(data, 0, buf, buf.length-data.length, data.length);
       try{
         test = jpg.decode(buf);
       }catch (IOException e) {
       }
       proc= 0;
     }
     else{
      // buf = expand(buf,data.length);
        if(proc==0){
         buf = data;
         proc=1;
        }
        else{
          buf = expand(buf,buf.length + data.length);
         arrayCopy(data, 0, buf, buf.length-1000, data.length);
        }
     }
 }
