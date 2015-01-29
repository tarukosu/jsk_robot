#!/usr/bin/env roseus
(ros::roseus "nano_command_receiver")
(require :attention-obserbation "package://jsk_demo_common/euslisp/attention-observation.l")
(ros::roseus-add-msgs "jsk_rviz_plugins")
(ros::roseus-add-msgs "std_msgs")

(setq *nano-receive-topic* "nano_receive_recover")
(pr2-init)

(defun callback(msg)
  (let()
    (cond
     ((equal (send msg :data) 6)
      (ros::ros-info "Start Request Recived")
      (ros::set-param "pause_motion_recover" "recover")
      (ros::publish *nano-receive-topic* (instance std_msgs::UInt8 :init :data 0))
      )
     ((equal (send msg :data) 7)
      (ros::ros-info "Stop Request Recived")
      (send *ri* :cancel-all-motion)
      (ros::publish *nano-receive-topic* (instance std_msgs::UInt8 :init :data 1))
      )
     ((equal (send msg :data) 8)
      (ros::ros-info "Canccel Request Recieved")
      (ros::publish *nano-receive-topic* (instance std_msgs::UInt8 :init :data 2))
      )
     (t
      )
     )
    )
  )

(ros::subscribe "select_image" std_msgs::UInt8 #'callback)
(ros::advertise *nano-receive-topic* std_msgs::UInt8 5)

(ros::spin)