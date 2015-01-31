#!/usr/bin/env roseus

(ros::roseus "pr2_state_fc")

(require :pr2-interface "package://pr2eus/pr2-interface.l")
(require :pr2-compressed-angle-vector-bridge "pr2-compressed-angle-vector-bridge.l")




(ros::advertise "/joint_states" sensor_msgs::JointState 1)
;;(pr2-init)
(setq *pr2* (pr2))

(setq dummy-joint-list 
      (list "fl_caster_rotation_joint" "fl_caster_l_wheel_joint" "fl_caster_r_wheel_joint" "fr_caster_rotation_joint" "fr_caster_l_wheel_joint" "fr_caster_r_wheel_joint" "bl_caster_rotation_joint" "bl_caster_l_wheel_joint" "bl_caster_r_wheel_joint" "br_caster_rotation_joint" "br_caster_l_wheel_joint" "br_caster_r_wheel_joint" "laser_tilt_mount_joint"))



;; (setq dummy-joint-list 
;;       (list "fl_caster_rotation_joint" "fl_caster_l_wheel_joint" "fl_caster_r_wheel_joint" "fr_caster_rotation_joint" "fr_caster_l_wheel_joint" "fr_caster_r_wheel_joint" "bl_caster_rotation_joint" "bl_caster_l_wheel_joint" "bl_caster_r_wheel_joint" "br_caster_rotation_joint" "br_caster_l_wheel_joint" "br_caster_r_wheel_joint" "laser_tilt_mount_joint"
;;       "r_gripper_joint" "r_gripper_l_finger_joint" "r_gripper_r_finger_joint" "r_gripper_r_finger_tip_joint" "r_gripper_l_finger_tip_joint" "r_gripper_motor_screw_joint" "r_gripper_motor_slider_joint" "l_gripper_joint" "l_gripper_l_finger_joint" "l_gripper_r_finger_joint" "l_gripper_r_finger_tip_joint" "l_gripper_l_finger_tip_joint" "l_gripper_motor_screw_joint" "l_gripper_motor_slider_joint"))

(defun l-gripper-callback
  (msg)
  (send *pr2* :larm :gripper :joint-angle (rad2deg (/ (send msg :data) 467.0)))
  )

(defun r-gripper-callback
  (msg)
  (send *pr2* :rarm :gripper :joint-angle (rad2deg (/ (send msg :data) 467.0)))
  )


(defun publish-state
  (msg)
  ;;(setq compressed-msg (init jsk_pr2_startup::AngleVectorCompressed :init :angles (send msg :joint_angles)))
  ;;(setq current-angle-vector (decompress-angle-vector *pr2* msg))
  (setq data nil)
  (dotimes (i (length (send *pr2* :angle-vector)))
    (push (elt (send msg :data) i) data))
  (send *pr2* :angle-vector data)

  ;;(send *pr2* :angle-vector current-angle-vector)
  ;;(setq js-msg (joint-list->joint_state (send *pr2* :joint-list)))

  (setq pos nil)
  (setq nlist nil)
  (setq plist nil)
  (setq vlist nil)
  (setq elist nil)

  (setq jlist (append (send *pr2* :joint-list)
		      (send *pr2* :larm :gripper :joint-list)
		      (send *pr2* :rarm :gripper :joint-list)))

  (dolist (j jlist)
    (let* ((n (send j :name))
	   (nm (if (symbolp n) (symbol-name n) n)))
      (push nm nlist)
      ;;(print pos)
      ;;(print (send j :ros-joint-angle))

      (unless pos
	(push (send j :ros-joint-angle) plist))
      ))
  

  ;; (setq name (send js-msg :name))
  ;; (setq p (send js-msg :position))
  ;; (setq velocity (send js-msg :velocity))
  ;; (setq effort (send js-msg :effort))

  (dolist (l dummy-joint-list)
    (push l nlist)
    (push 0 plist)
    )

  (setq js-msg
	(instance sensor_msgs::JointState :init
		  :header (instance std_msgs::Header :init :stamp (ros::time-now))
		  :name (nreverse nlist)
		  :position (if pos plist
			      (coerce (nreverse plist) float-vector))
		  :velocity vlist
		  :effort elist))


  (ros::publish "/joint_states" js-msg)
  (x::window-main-one)
  )

(ros::subscribe "/angle_vector_compressed" std_msgs::Float32MultiArray
		#'publish-state)

(ros::subscribe "/l_gripper_angle_vector_compressed" std_msgs::UInt8
		#'l-gripper-callback)

(ros::subscribe "/r_gripper_angle_vector_compressed" std_msgs::UInt8
		#'r-gripper-callback)



;; (defun publish-compressed-joint-state ()
;;   (let ((msg (compress-angle-vector *pr2* (send *ri* :state :potentio-vector))))
;;     (setq send-msg (instance jsk_pr2_startup::FC2OCS :init))
;;     (send send-msg :joint_angles (send msg :angles))
;;     (ros::ros-info "compressed msg: ~A" (send *ri* :state :potentio-vector))
;;     (ros::publish "fc2ocs_lowspeed" send-msg)
;;     ))
(objects (list *pr2*))
;;(ros::rate 1)0
(ros::spin)
;;(while (ros::ok)
;;       (ros::spin-once)
;;       (publish-compressed-joint-state)
;;       (ros::sleep)
)
