#!/usr/bin/env python
import rospy
from sensor_msgs.msg import CameraInfo

camera_info = CameraInfo()
camera_info.header.frame_id = "/openni_rgb_optical_frame"
camera_info.height = 480
camera_info.width = 640
camera_info.distortion_model = "plumb_bob"
camera_info.D = [0.0, 0.0, 0.0, 0.0, 0.0]
camera_info.K = [525.0, 0.0, 319.5, 0.0, 525.0, 239.5, 0.0, 0.0, 1.0]
camera_info.R = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0]
camera_info.P = [525.0, 0.0, 319.5, 0.0, 0.0, 525.0, 239.5, 0.0, 0.0, 0.0, 1.0, 0.0]

rospy.init_node('publish_camera_info')
pub = rospy.Publisher('output', CameraInfo, queue_size=10)

r = rospy.Rate(1)
while not rospy.is_shutdown():
    pub.publish(camera_info)
    r.sleep()
