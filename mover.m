function mover(distance, speed)
    pub = rospublisher('/raw_vel');
    sub_states = rossubscriber('/gazebo/model_states', 'gazebo_msgs/ModelStates');
    msg = rosmessage(pub);
    msg.Data = [0, 0];
    send(pub, msg);
    pause(.05)
    
    start= rostime('now');
    while true
        linnear_speed=speed;
        time=distance/linnear_speed;
        msg.Data = [speed, speed];
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



% function move_time= mover(i, tracked_gradient_norm)
%     move_time=(norm(tracked_gradient_norm(i,:)/.1));
% end
% 
