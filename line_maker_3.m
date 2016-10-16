clc
%clear all
close all
center = [-5 20]
%center = [-10 20];
radius = 6; 
l1 = 15;
l2 = 15;
%r = ;
angles = []
ang = 1
theta1 = 0:180;
theta2 = 0:180;
for i = 1 :181  
    for j = 1 :181
x(i,j) = l1*cosd(theta1(i)) + l2*cosd(theta1(i) + theta2(j));
y(i,j) = l1*sind(theta1(i)) + l2*sind(theta1(i) + theta2(j));
angles(i*180 + j,:) = [theta1(i) theta2(j)];
ang = ang + 1 ; % to store  the corresponding angles
    end
end


eccentricity = 0.9
plot(x,y,'r.')
hold on
%axis square
theta3 = 0: 360;
x1 = radius*cosd(theta3) + center(1);
y1 = radius*eccentricity*sind(theta3) + center(2);
plot(x1,y1,'g')
a = [];
t = 1;
% now rounding off to 0.1
x2 = x1*10;
y2 = y1*10;
x2 = round(x2);
y2 = round(y2);
x3 = x2/10;
y3 = y2/10;
plot(x3,y3,'b');
angles2 = []
tolerance = .1; % good curves for 0.5 , 0.6 , 0.7 0.8 etc 
for k = 1: 361
    for i = 1: 181
        for j =1 :181
            %if (x(i,j) == x1(k) && y(i,j) == y1(k))
            if((x(i,j) + tolerance >= x3(k)) && (x(i,j) - tolerance <= x3(k)) && (y(i,j) + tolerance >= y3(k)) && (y(i,j) - tolerance <= y3(k))) 
            a(t,:) = [x(i,j),y(i,j)]
            angles2(t,:) = angles(180*i + j,:);    
            t = t+1
                
            end
        end
    end
end
%figure(2)
figure(2)
axis square
comet(a(:,1),a(:,2))
%%
%ard = arduino('COM8');
ard.pinMode(9,'OUTPUT');
ard.pinMode(10,'OUTPUT');
ard.pinMode(13,'OUTPUT');

ard.servoAttach(9);% 9 is the theta1 one i.e. the base servo
ard.servoAttach(10);% 10 is the theta2 one i.e. the moving servo
%%
ard.servoWrite(9,90);
 ard.servoWrite(10,90);
figure(3),
 for i = 1:length(angles2)
    ard.servoWrite(9,angles2(i,1));
    ard.servoWrite(10,angles2(i,2));
    disp(angles2(i,:))
    plot( l1*cosd(angles2(i,1)) + l2*cosd(angles2(i,1) + angles2(i,2)), l1*sind(angles2(i,1)) + l2*sind(angles2(i,1) + angles2(i,2)),'r*')
    hold on
    axis square
    pause(.1);
end

% 
% for i = 1:l
%     p = 0;
%     for k = 1:t
%         if a1(k) == a(i)
%             p = 1
%         end
%     end
%     if p != 1
%         a
%figure, plot(a(1),a(2))