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

    #Start Button
    if msg.buttons[6] == 1:
        pub_msg.data = 6
        # print pub_msg
        pub.publish(pub_msg)
        # rospy.set_param('pause_motion_recover', "recover")
        print "pause_motion_recover is set to RECOVER"
    #Stop Button
    if msg.buttons[14] == 1:
        pub_msg.data = 7
        # print pub_msg
        pub.publish(pub_msg)
        # rospy.set_param('/attention_observation/flag', True)
        # pub_msg.data = 7
        print "Stop is sent"

    #Cancel Button
    if msg.buttons[15] == 1:
        pub_msg.data = 8
        # print pub_msg
        pub.publish(pub_msg)
        print "Cancel is sent"



rospy.init_node('select_image')
sub = rospy.Subscriber ('nanopad2/joy', Joy, joy_cb)
pub = rospy.Publisher('select_image', UInt8, queue_size=10)

rospy.spin()
# r = rospy.Rate(1)
# while not rospy.is_shutdown():
#     pub.publish(camera_info)
#     r.sleep()
