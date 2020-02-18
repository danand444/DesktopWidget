/*
Arduino 2x16 LCD - Detect Buttons
modified on 18 Feb 2019
by Saeed Hosseini @ Electropeak
https://electropeak.com/learn/
*/
#include <LiquidCrystal.h>
int incomingByte = 0;
//LCD pin to Arduino
const int pin_RS = 8; 
const int pin_EN = 9; 
const int pin_d4 = 4; 
const int pin_d5 = 5; 
const int pin_d6 = 6; 
const int pin_d7 = 7; 
const int pin_BL = 10;
const int pin_RED = A1;
const int pin_GREEN = A3;
const int pin_BLUE = A5;
LiquidCrystal lcd( pin_RS,  pin_EN,  pin_d4,  pin_d5,  pin_d6,  pin_d7);


void setup() {
 lcd.begin(16, 2);
 lcd.setCursor(0,0);
 lcd.setCursor(0,1);
 Serial.begin(9600);
 pinMode(pin_RED, OUTPUT);
 pinMode(pin_GREEN, OUTPUT);
 pinMode(pin_BLUE, OUTPUT);
 
}
void loop() {
 int x;
 String incomingMessage;
 x = analogRead (0);
 lcd.setCursor(10,1);
 if (x < 60) {
   lcd.print ("Right ");
 }
 else if (x < 200) {
   lcd.print ("Up    ");
 }
 else if (x < 400){
   lcd.print ("Down  ");
 }
 else if (x < 600){
   lcd.print ("Left  ");
 }
 else if (x < 800){
   lcd.print ("Select");
 }
 if (Serial.available() > 0) {
    // read the incoming byte:
    incomingByte = Serial.read();
    incomingMessage = Serial.readString();
    // say what you got:
    Serial.print("I received: ");
    Serial.println(incomingByte, DEC);
    lcd.begin(16, 2);
    lcd.setCursor(0,0);
    lcd.print("Computer Stats");
    lcd.setCursor(0,1);
    lcd.print(incomingMessage);
if(incomingMessage.indexOf("#GREEN#") > 0){
digitalWrite(pin_RED, LOW);
digitalWrite(pin_BLUE, LOW);
digitalWrite(pin_GREEN, HIGH);
  }
if(incomingMessage.indexOf("#YELLOW#") > 0){
digitalWrite(pin_RED, HIGH);
digitalWrite(pin_BLUE, LOW);
digitalWrite(pin_GREEN, HIGH);
  }
if(incomingMessage.indexOf("#RED#") > 0){
digitalWrite(pin_RED, HIGH);
digitalWrite(pin_BLUE, LOW);
digitalWrite(pin_GREEN, LOW);
  }
}
}
