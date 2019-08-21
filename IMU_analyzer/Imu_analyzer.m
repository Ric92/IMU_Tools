clear all
clc
close all
filename = '/home/ric92/programming/arduino/IMU-ReadData/Serial1566394400.77.txt';
%% get data from logfile
[time, ax,ay,az, roll, pitch, yaw, girox, giroy, giroz, magnex, magney, magnez] = textread(filename, '%f %f %f %f %f %f %f %f %f %f %f %f %f' );
realDistance = 1.73;
[time0, timeIndexMin] = min(time);
[timef, timeIndexMax] = max(time);
scaleFactor = 9.81/256;
ax = ax * scaleFactor;
ay = ay * scaleFactor;
az = az * scaleFactor;
az = az - 9.81;

%% cut offset
offsetX = 0;
offsetY = 0;
offsetZ = 0;
numMeasurement = 100;
for i = 1:numMeasurement
  offsetX = offsetX + ax(i);
  offsetY = offsetY + ay(i); 
  offsetZ = offsetZ + az(i);  
 end
offsetX = offsetX/numMeasurement;
offsetY = offsetY/numMeasurement; 
offsetZ = offsetZ/numMeasurement; 
 
ax = ax - offsetX;
ay = ay - offsetY;
az = az - offsetZ;
 
% refresh rate
Hz = 1/((timef-time0)/length(time));
disp("Refresh rate = ")
disp(Hz)

% distance calculation
vx = [0];vy = [0];vz = [0];
px = [0];py = [0];pz = [0];

for i = 2:length(time)
  vx(i) = vx(i-1) + ax(i) * (time(i)-time(i-1));
  vy(i) = vy(i-1) + ay(i) * (time(i)-time(i-1));
  vz(i) = vz(i-1) + az(i) * (time(i)-time(i-1));
  
  px(i) = px(i-1) + vx(i-1) * (time(i)-time(i-1)) ;#+ 0.5 * ax(i) * (time(i)-time(i-1))^2;
  py(i) = py(i-1) + vy(i-1) * (time(i)-time(i-1)) ;#+ 0.5 * ay(i) * (time(i)-time(i-1))^2;
  pz(i) = pz(i-1) + vz(i-1) * (time(i)-time(i-1)) ;#+ 0.5 * az(i) * (time(i)-time(i-1))^2;
end



%% plot 1
figure(1)
subplot(3,1,1)
plot(time,roll)
ylabel('roll','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,2)
plot(time,pitch)
ylabel('pitch','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,3)
plot(time,(yaw))
ylabel('yaw','FontSize',30)
xlim([time0 timef])
grid on

%% plot 2
figure(2)
subplot(3,1,1)
plot(time,ax)
hold on
ylabel('ax','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,2)
plot(time,ay)
ylabel('ay','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,3)
plot(time,(az))
ylabel('az','FontSize',30)
xlim([time0 timef])
grid on

%% plot 3
figure(3)
subplot(3,1,1)
plot(time,vx)
hold on
ylabel('vx','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,2)
plot(time,vy)
ylabel('vy','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,3)
plot(time,(vz))
ylabel('vz','FontSize',30)
xlim([time0 timef])
grid on

%% plot 4
figure(4)
subplot(3,1,1)
plot(time,px)
hold on
ylabel('px','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,2)
plot(time,py)
ylabel('py','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,3)
plot(time,(pz))
ylabel('pz','FontSize',30)
xlim([time0 timef])
grid on

%% plot 5
figure(5)
subplot(3,1,1)
hold on
plot(time,px)
plot(time,ax)
ylabel('ax-px','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,2)
hold on
plot(time,py)
plot(time,ay)
hold on
ylabel('ay-py','FontSize',30)
xlim([time0 timef])
grid on
subplot(3,1,3)
hold on
plot(time,(pz))
plot(time,az)
hold on
ylabel('az-pz','FontSize',30)
xlim([time0 timef])
grid on


