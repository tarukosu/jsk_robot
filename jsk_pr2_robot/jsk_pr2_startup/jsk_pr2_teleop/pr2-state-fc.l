#!/usr/bin/env roseus

(ros::roseus "pr2_state_fc")

(require :pr2-interface "package://pr2eus/pr2-interface.l")
(require :pr2-compressed-angle-vector-bridge "pr2-compressed-angle-vector-bridge.l")

(ros::advertise "fc2ocs_lowspeed" jsk_pr2_startup::FC2OCS 1)

(pr2-init)

(defun publish-compressed-joint-state ()
  (let ((msg (compress-angle-vector *pr2* (send *ri* :state :potentio-vector))))
    (setq send-msg (instance jsk_pr2_startup::FC2OCS :init))
    (send send-msg :joint_angles (send msg :angles))
    (ros::ros-info "compressed msg: ~A" (send *ri* :state :potentio-vector))
    (ros::publish "fc2ocs_lowspeed" send-msg)
    ))

(ros::rate 10)

(while (ros::ok)
       (ros::spin-once)
       (publish-compressed-joint-state)
       (ros::sleep))
