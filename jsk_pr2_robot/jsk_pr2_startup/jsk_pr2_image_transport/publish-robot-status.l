#!/usr/bin/env roseus

(ros::roseus-add-msgs "jsk_rviz_plugins")
(ros::roseus "publish_status")


(defun overlay-text-color
 (status &key (a 0.8))
 (let ((color (instance std_msgs::ColorRGBA :init)))
   (case status
     (:INFO
      (send color :r (/ 25 255.0))
      (send color :g (/ 255 255.0))
      (send color :b (/ 255 255.0))
      )
     (:WARNING
      (send color :r (/ 255 255.0))
      (send color :g (/ 255 255.0))
      (send color :b (/ 0 255.0))
      )
     (:ERROR
      (send color :r (/ 255 255.0))
      (send color :g (/ 0 255.0))
      (send color :b (/ 0 255.0))
      )
     )
   (send color :a a)
   color
   ))


(defun publish-status
  (msg &optional (correct t))
  (when correct
    (setq old-msg msg)
    )
  (let ((text_msg (instance jsk_rviz_plugins::OverlayText :init))
	text)
    (setq text_size 20)
    (setq st (send msg :data))
    (cond 
     ((equal st 0)
      (setq text "running")
      (send text_msg :fg_color (overlay-text-color :INFO))
      )
     ((equal st 1)
      (setq text "pause")
      (send text_msg :fg_color (overlay-text-color :ERROR))
      )
     ((equal st 3)
      (setq text "delay")
      (send text_msg :fg_color (overlay-text-color :WARNING))
      ))
    ;; (setq text (concatenate string
    ;; 			    (format nil " ik:            ~A~%" (if *ik-stop* "stop" "running"))
    ;; 			    (format nil " move-arm:      ~A~%" *move-limb*)
    ;; 			    (format nil " target-coords: ~A~%" *origin-key*)
    ;; 			    (format nil " ik-mode:       ~A~%" (if *rotation-axis* "6D" "3D"))
    ;; 			    (format nil " move-link:     ~A~%" (cond (*use-torso* "torso")
    ;; 								     (*use-fullbody* "fullbody")
    ;; 								     (t "arm")
    ;; 								     ))
    ;; 			    (format nil " ik-update:     ~A~%" *ik-update-times*)
    ;; 			    (format nil " target-update: ~A~%" *target-update-times*)
    ;; 			    ))
    (setq delete nil)
    (if delete
	(send text_msg :action jsk_rviz_plugins::OverlayText::*DELETE*)
      (send text_msg :action jsk_rviz_plugins::OverlayText::*ADD*)
      )
    (send text_msg :width 400)
    (send text_msg :height 240)
    (send text_msg :top 104)
    ;;(send text_msg :fg_color (send self :overlay-text-color status))
    (send text_msg :bg_color :a 0.2)
    (send text_msg :line_width 2)
    (send text_msg :text_size 20)
    (send text_msg :font "DejaVu Sans Mono")
    (send text_msg :text text)
    (ros::publish "/robot_status_text" text_msg)
    ))

(defun check-network
  (msg)
  (cond 
   ((> (send msg :data) 0.5)
    (publish-status (instance std_msgs::UInt8 :init :data 3) nil)
    (print "delay")
    )
   (t
    (publish-status old-msg)
    )
   )
  )

(setq old-msg (instance std_msgs::UInt8 :init :data 0))

(ros::subscribe "/robot_status"  std_msgs::UInt8 #'publish-status)
(ros::subscribe "/heartbeat/round_time"  std_msgs::Float32 #'check-network)
(ros::advertise "/robot_status_text"  jsk_rviz_plugins::OverlayText)


(ros::spin)
