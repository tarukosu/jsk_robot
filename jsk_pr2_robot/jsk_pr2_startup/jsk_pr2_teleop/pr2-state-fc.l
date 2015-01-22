#!/usr/bin/env roseus

(ros::roseus "pr2_state_fc")

(require :pr2-interface "package://pr2eus/pr2-interface.l")
(require :pr2-compressed-angle-vector-bridge "pr2-compressed-angle-vector-bridge.l")

(ros::advertise "angle_vector_compressed" jsk_pr2_startup::AngleVectorCompressed 1)

(pr2-init)

(defun publish-compressed-joint-state ()
  (let ((msg (compress-angle-vector *pr2* (send *ri* :state :potentio-vector))))
    (ros::ros-info "compressed msg: ~A" (send *ri* :state :potentio-vector))
    (ros::publish "angle_vector_compressed" msg)
    ))

(ros::rate 10)

(while (ros::ok)
       (ros::spin-once)
       (publish-compressed-joint-state)
       (ros::sleep))
