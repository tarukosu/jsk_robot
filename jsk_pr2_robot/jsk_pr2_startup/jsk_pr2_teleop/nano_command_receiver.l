#!/usr/bin/env roseus
(ros::roseus "nano_command_receiver")
(require :attention-obserbation "package://jsk_demo_common/euslisp/attention-observation.l")
(ros::roseus-add-msgs "jsk_rviz_plugins")
(ros::roseus-add-msgs "std_msgs")

(setq *nano-receive-topic* "robot_status")
(pr2-init)

(setq *state* :start)
(setq *network-thre* 0.3)

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
      (setq *state* :stop)
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

(defun network-callback (msg)
  (let ((time (send msg :data)))
    (cond
     ((< time *network-thre*)
      (when (equal *state* :network-stop)
	(setq *state* :start)
	(ros::publish *nano-receive-topic* (instance std_msgs::UInt8 :init :data 0))
	))
     (t
      (when (equal *state* :start)
	(setq *state* :network-stop)
	(ros::publish *nano-receive-topic* (instance std_msgs::UInt8 :init :data 3))
	))
     ))
  )

(ros::subscribe "heartbeat/round_time" std_msgs::Float32 #'network-callback)
(ros::subscribe "select_image" std_msgs::UInt8 #'callback)
(ros::advertise *nano-receive-topic* std_msgs::UInt8 5)

(ros::spin)