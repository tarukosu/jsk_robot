#!/usr/bin/env python
import rospy
from sensor_msgs.msg import Joy
from std_msgs.msg import UInt8


def joy_cb(msg):
    pub_msg = UInt8()
    if msg.buttons[0] == 1:
        pub_msg.data = 0
        print pub_msg
        pub.publish(pub_msg)
    if msg.buttons[8] == 1:
        pub_msg.data = 1
        print pub_msg
        pub.publish(pub_msg)
    if msg.buttons[1] == 1:
        pub_msg.data = 2
        print pub_msg
        pub.publish(pub_msg)
    if msg.buttons[9] == 1:
        pub_msg.data = 3
        print pub_msg
        pub.publish(pub_msg)
    if msg.buttons[2] == 1:
        pub_msg.data = 4
        print pub_msg
        pub.publish(pub_msg)
    if msg.buttons[10] == 1:
        pub_msg.data = 5
        print pub_msg
        pub.publish(pub_msg)



rospy.init_node('select_image')
sub = rospy.Subscriber ('nanopad2/joy', Joy, joy_cb)
pub = rospy.Publisher('select_image', UInt8, queue_size=10)

rospy.spin()
# r = rospy.Rate(1)
# while not rospy.is_shutdown():
#     pub.publish(camera_info)
#     r.sleep()
