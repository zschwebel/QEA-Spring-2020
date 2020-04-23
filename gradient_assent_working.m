clear all
syms X Y

f=(X.*Y)-(X.^2)-(Y.^2)-(2*X)-(2*Y)+4;
[X1,Y1] = meshgrid(-3:.1:1,-3:.1:1);
Z=(X1.*Y1)-(X1.^2)-(Y1.^2)-(2*X1)-(2*Y1)+4;
contourf(X1,Y1,Z,10)

hold on
plot(1,-1,'r*','LineWidth',5);

%%
clf
clear figure

G = gradient(f);

figure
[gx,gy] = gradient(Z,.1,.1);
quiver(X1,Y1,gx,gy);

figure
contourf(X1,Y1,Z,10)
hold on

pos_x= 1;
pos_y= -1;
lambda=.1;
tracked_pos=zeros(66,2);
tracked_gradient_norm=zeros(66,2);
lin_speed=.1;
wheelbase=.235;

ending=round(3.35/lambda);

for i=1:1:ending
    gradient_vector=double(subs(G, {X,Y}, {pos_x, pos_y}));
    gradient_scaled=gradient_vector.*lambda;
    gradient_norm=lambda*(gradient_vector/norm(gradient_vector));
%     disp(gradient_norm)
    quiver(pos_x,pos_y,gradient_norm(1), gradient_norm(2))
    pos_x = pos_x + gradient_norm(1,1);
    pos_y = pos_y + gradient_norm(2,1);
    tracked_gradient_norm(i,:)=gradient_norm;
    tracked_pos(i,:)=[pos_x, pos_y];
end

for i=2:1:ending
    Angle=norm(tracked_gradient_norm(i,:)/lambda - tracked_gradient_norm(i-1,:)/lambda);
    Tracked_angle((i-1),:)=Angle;
end


%%
pub = rospublisher('/raw_vel');
sub_states = rossubscriber('/gazebo/model_states', 'gazebo_msgs/ModelStates');
msg = rosmessage(pub);

posX=1;
posY=-1;
headingX=0;
headingY=1;
headingX=-0.0981;
headingY=0.0196;
placeNeato(posX, posY, headingX, headingY)

vec1=[0;1];
vec2=[-0.0981;0.0196];

angle_to_start=acos(dot(vec1,vec2));





% make sure robot starts out with 0 velocity
msg.Data = [0, 0];
send(pub, msg);
pause(2);

%testy(40)
lin_speed=.08;
ang_speed=.02;

% rotate(-angle_to_start, ang_speed)
% pause(.5)

for i=1:1:(ending-1)
    mover(norm(tracked_gradient_norm(i,:)),lin_speed)
    rotate(-Tracked_angle(i), ang_speed)
end


msg.Data = [0, 0];
send(pub, msg);

