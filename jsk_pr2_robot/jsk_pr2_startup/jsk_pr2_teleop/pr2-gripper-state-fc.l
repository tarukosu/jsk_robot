#!/usr/bin/env roseus

(ros::roseus "pr2_gripper_state_fc")

;;(require :pr2-interface "package://pr2eus/pr2-interface.l")
;;(require :pr2-compressed-angle-vector-bridge "pr2-compressed-angle-vector-bridge.l")

(ros::roseus-add-msgs "sensor_msgs")

(defun compress-gripper-angle
  (pos)
  (setq pos (round (* 467 pos)))
  (cond
   ((< pos 0)
    (setq pos 0))
   ((> pos 255)
    (setq pos 255))
   )
  (instance std_msgs::UInt8 :init :data pos)
  )
  
(defun r-gripper-callback
  (msg)
  (ros::publish "r_gripper_angle_vector_compressed" (compress-gripper-feedback msg))
  )

(defun l-gripper-callback
  (msg)
  (ros::publish "l_gripper_angle_vector_compressed" (compress-gripper-feedback msg))
  )

(defun js-callback
  (msg)
  (dotimes (i (length (send msg :name)))
    (setq name (elt (send msg :name) i))
    ;;(print name)
    (when (equal name "r_gripper_l_finger_joint")
      (setq pos (elt (send msg :position) i))
      ;;(print  pos)
      (ros::publish "r_gripper_angle_vector_compressed" (compress-gripper-angle pos))
      )
    (when (equal name "l_gripper_l_finger_joint")
      (setq pos (elt (send msg :position) i))
      (ros::publish "l_gripper_angle_vector_compressed" (compress-gripper-angle pos))
      )

    )
  )

(ros::subscribe "/joint_states"
		sensor_msgs::JointState #'js-callback)

(ros::advertise "r_gripper_angle_vector_compressed" std_msgs::UInt8 1)
(ros::advertise "l_gripper_angle_vector_compressed" std_msgs::UInt8 1)

(ros::spin)
