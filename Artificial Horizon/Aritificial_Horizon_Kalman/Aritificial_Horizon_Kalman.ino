#include<Wire.h> // wire library
#include<SimpleKalmanFilter.h>

const int MPU_addr=0x68; // MPU address

int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ; // 16 bit data array

int minVal=265;
int maxVal=402;

SimpleKalmanFilter kfx = SimpleKalmanFilter(0.16, 0.4, 0.01);
SimpleKalmanFilter kfy = SimpleKalmanFilter(0.16, 0.4, 0.01);
SimpleKalmanFilter kfz = SimpleKalmanFilter(0.16, 0.4, 0.01);

float X_est, Y_est, Z_est;
double x; double y; double z;

void setup() {
Serial.begin(9600);
Wire.begin();
Wire.beginTransmission(MPU_addr);
Wire.write(0x6B);
Wire.write(0);
Wire.endTransmission(true);

}

void loop() {
Wire.beginTransmission(MPU_addr);
Wire.write(0x3B);
Wire.endTransmission(false);
Wire.requestFrom(MPU_addr,14,true);
AcX=Wire.read()<<8|Wire.read();
AcY=Wire.read()<<8|Wire.read();
AcZ=Wire.read()<<8|Wire.read();

 int xAng = map(AcX,minVal,maxVal,-90,90);
int yAng = map(AcY,minVal,maxVal,-90,90);
int zAng = map(AcZ,minVal,maxVal,-90,90);



x= RAD_TO_DEG * (atan2(-yAng, -zAng)+PI);
y= RAD_TO_DEG * (atan2(-xAng, -zAng)+PI);
z= RAD_TO_DEG * (atan2(-yAng, -xAng)+PI);


X_est = kfx.updateEstimate(x);
Y_est = kfy.updateEstimate(y);
Z_est = kfz.updateEstimate(z);

// Uncomment this part for results with Kalman Filter

//Serial.print(X_est);
//Serial.print(" ");
//Serial.print(Y_est);
//Serial.print(" ");
//Serial.print(Z_est);
//Serial.print("\n");
//

// Uncomment this part for results without Kalman filter
//Serial.print(x);
//Serial.print(" ");
//Serial.print(y);
//Serial.print(" ");
//Serial.print(z);
//Serial.print("\n");

 }
