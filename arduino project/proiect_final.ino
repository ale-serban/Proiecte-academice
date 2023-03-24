#include <SoftwareSerial.h>
#include <Servo.h>
Servo srv;
#define servo_pin 4

// Pini motor 1
#define motor1_pin1 5
#define motor1_pin2 6
// Pini motor 2
#define motor2_pin1 3
#define motor2_pin2 11
#define motor_speed 128
#define interval_ON 500
#define interval_OFF 1000

// Pini ultrasonic sensor
#define echoPin 10
#define trigPin 9
// RGB lights
#include <Adafruit_NeoPixel.h>
#define neopixel_pin 7
#define num_pixels 16
Adafruit_NeoPixel strip = Adafruit_NeoPixel(num_pixels, neopixel_pin, NEO_GRB + NEO_KHZ800);
// buzzer
int melody[] = {262, 196, 196, 220, 196, 0, 247, 262}; //frecvente de note muzicale
int noteDurations[] = {4, 8, 8, 4, 4, 4, 4, 4 };

#define buzzer_pin 2

char t;

// Functia setup() se executa o singura data, la inceputul programului
void setup() {
     Serial.begin(9600); // Interfata Serial 0, pentru PC

  // configurarea pinilor motor ca iesire, initial valoare 0
  pinMode(motor1_pin1, OUTPUT);
  pinMode(motor1_pin2, OUTPUT);
  pinMode(motor2_pin1, OUTPUT);
  pinMode(motor2_pin2, OUTPUT);
  digitalWrite(motor1_pin1, 0);
  digitalWrite(motor1_pin2, 0);
  digitalWrite(motor2_pin1, 0);
  digitalWrite(motor2_pin2, 0);
  pinMode(buzzer_pin, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(servo_pin, OUTPUT);
  pinMode(neopixel_pin, OUTPUT);
  Serial.begin(9600); //functie pentru pornirea interfetei seriale, pentru debugging
  strip.begin(); //initializarea benzii de LED-uri RGB
  strip.setBrightness(50); //setarea luminozitatii pentru banda de LED-uri (maxim 255)
  strip.show(); //afisarea benzii de LED-uri
  functie_pornire();
  functie_melodie();
}
// Functia loop() se executa repetitiv
void loop() {
  if (Serial.available()){
    t = Serial.read();
    Serial.println(t);
  }
  if(t == '1'){
    playWithServo(servo_pin);
    move_robot_forward();
    delay(interval_ON);
    delayStopped(interval_OFF);
  }
  else if(t == '2'){
    playWithServo(servo_pin);
     move_robot_backward();
    delay(interval_ON);
    delayStopped(interval_OFF);
  }
  else if(t == '3'){
    playWithServo(servo_pin);
     move_robot_left();
    delay(interval_ON);
    delayStopped(interval_OFF);
  }
  else if(t == '4'){
    playWithServo(servo_pin);
     move_robot_right();
    delay(interval_ON);
    delayStopped(interval_OFF);
  }
  delay(100);
  // playWithServo(servo_pin);
  // move_robot_forward();
  // delay(interval_ON);
  // delayStopped(interval_OFF);
  // move_robot_backward();
  // delay(interval_ON);
  // delayStopped(interval_OFF);
  // move_robot_left();
  // delay(interval_ON);
  // delayStopped(interval_OFF);
  // move_robot_right();
  // delay(interval_ON);
  // delayStopped(interval_OFF);
}

// Funcție pentru controlul unui motor. Intrare: cei doi pini ai unui motor, direcția (0/1) și viteza de rotatie a motorului (semnal PWM)
void StartMotor (int m1, int m2, int forward, int speed)
{
  if (speed == 0) {
    digitalWrite(m1, 0); // oprire
    digitalWrite(m2, 0);
  } else {
    if (forward) {
      digitalWrite(m2, 0);
      analogWrite(m1, speed); // folosire PWM
    } else {
      digitalWrite(m1, 0);
      analogWrite(m2, speed);
    }
  }
}
// Funcție de oprire a ambelor motoare, urmată de delay
void delayStopped(int ms)
{
  StartMotor (motor1_pin1, motor1_pin2, 0, 0);
  StartMotor (motor2_pin1, motor2_pin2, 0, 0);
  delay(ms);
}

void playWithServo(int pin)
{
  srv.attach(pin);
  for (int i = 90; i > 40; i -= 5) {
    srv.write(i);
    check_distance();
    delay(50);
  }
  for (int i = 40; i < 150; i += 5) {
    srv.write(i);
    check_distance();
    delay(50);
  }
  for (int i = 150; i > 40; i -= 5) {
    srv.write(i);
    check_distance();
    delay(50);
  }
  for (int i = 40; i < 90; i += 5) {
    srv.write(i);
    check_distance();
    delay(50);
  }
  srv.detach();
}

// Functie pentru verificarea distantei pana la obstacol si actionarea motoarelor si a LED-urilor in functie de obstacol
void check_distance() {
  int distance = measure_distance();
  Serial.println(distance);
  if (distance < 30) {
    for (int i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, strip.Color(255, 0, 0)); //turn LEDs red
    }
    strip.show();
    delayStopped(50); //stop motors
    while (distance < 30) {
      clear_leds();
      noTone(buzzer_pin);
      delay(200);
      for (int i = 0; i < strip.numPixels(); i++) {
        strip.setPixelColor(i, strip.Color(255, 0, 0)); //turn LEDs red
      }
      strip.show();
      tone(buzzer_pin, melody[1], 200);
      delay(200);
      distance = measure_distance();
    }
  }
  else {
    StartMotor (motor1_pin1, motor1_pin2, 0, 0);
    StartMotor (motor2_pin1, motor2_pin2, 0, 0);
    for (int i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, strip.Color(0, 255, 0)); //turn LEDs green
    }
    strip.show();
  }
}
// Functie pentru masurarea distantei pana la cel mai apropiat obstacol cu ajutorul senzorului ultrasonic. Returneaza distanta in cm
int measure_distance() {
  long duration; // variable for the duration of sound wave travel
  int distance; // variable for the distance measurement
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  return distance;
}
// Functie care reda o melodie pe buzzer
void functie_melodie() {
  for (int thisNote = 0; thisNote < 8; thisNote++) {
    int noteDuration = 1000 / noteDurations[thisNote];
    tone(buzzer_pin, melody[thisNote], noteDuration);
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    noTone(buzzer_pin);
  }
}
// Functie pentru afisarea unei animatii pe LED-uri la pornire
void functie_pornire() {
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(255, 0, 255));
    strip.show();
    delay(40);
  }
  delay(200);
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(0, 0, 0));
    strip.show();
    delay(40);
  }
  delay(200);
}
// Functie pentru miscarea robotului in fata
void move_robot_forward() {
  show_LEDs_forward();
  StartMotor (motor1_pin1, motor1_pin2, 0, motor_speed);
  StartMotor (motor2_pin1, motor2_pin2, 0, motor_speed);
}
void show_LEDs_forward() {
  clear_leds();
  for (int i = 0; i <= 3; i++) {
    strip.setPixelColor(i, strip.Color(0, 255, 0));
  }
  for (int i = 12; i <= 15; i++) {
    strip.setPixelColor(i, strip.Color(0, 255, 0));
  }
  strip.show();
}
// Functie pentru miscarea robotului in spate
void move_robot_backward() {
  show_LEDs_backward();
  StartMotor (motor1_pin1, motor1_pin2, 1, motor_speed);
  StartMotor (motor2_pin1, motor2_pin2, 1, motor_speed);
}
void show_LEDs_backward() {
  clear_leds();
  for (int i = 4; i <= 11; i++) {
    strip.setPixelColor(i, strip.Color(0, 255, 0));
  }
  strip.show();
}
// Functie pentru miscarea robotului in stanga
void move_robot_left() {
  show_LEDs_left();
  StartMotor (motor1_pin1, motor1_pin2, 0, motor_speed);
  StartMotor (motor2_pin1, motor2_pin2, 1, motor_speed);
}
void show_LEDs_left() {
  clear_leds();
  for (int i = 0; i <= 7; i++) {
    strip.setPixelColor(i, strip.Color(0, 255, 255));
  }
  strip.show();
}
// Functie pentru miscarea robotului in dreapta
void move_robot_right() {
  show_LEDs_right();
  StartMotor (motor1_pin1, motor1_pin2, 1, motor_speed);
  StartMotor (motor2_pin1, motor2_pin2, 0, motor_speed);
}
void show_LEDs_right() {
  clear_leds();
  for (int i = 8; i <= 15; i++) {
    strip.setPixelColor(i, strip.Color(255, 0, 255));
  }
  strip.show();
}
// Functie pentru oprirea LED-urilor
void clear_leds() {
  for (int i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, strip.Color(0, 0, 0));
  }
  strip.show();
}