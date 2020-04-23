function rotate(ang1e, speed)
    pub = rospublisher('/raw_vel');
    sub_states = rossubscriber('/gazebo/model_states', 'gazebo_msgs/ModelStates');
    msg = rosmessage(pub);
    msg.Data = [0, 0];
    send(pub, msg);
    pause(.05)
    
    sign_use=sign(ang1e);
    
    start= rostime('now');
    while true
        wheelbase=.235;
        Angular_speed=((2*speed)/wheelbase);
        time=(abs(ang1e))/Angular_speed;
        msg.Data = [(sign_use*speed), (-sign_use*speed)];
        send(pub, msg);
        currTime = rostime('now');
        elapsedTime = currTime - start;
        ros_time = elapsedTime.seconds;
        if ros_time > time
        break
        end
    end
    msg.Data = [0, 0];
    send(pub, msg);
    pause(.01)
    
    
end