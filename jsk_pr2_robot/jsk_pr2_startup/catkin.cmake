cmake_minimum_required(VERSION 2.8.3)
project(jsk_pr2_startup)
find_package(catkin REQUIRED COMPONENTS message_generation std_msgs sensor_msgs jsk_network_tools jsk_interactive_marker)

add_message_files(FILES AngleVectorCompressed.msg FC2OCS.msg FC2OCSHeartBeat.msg FC2OCSLargeData.msg OCS2FC.msg OCS2FCHeartBeat.msg OCS2FCLargeData.msg
FC2OCSHeadResizedImage.msg FC2OCSLarmResizedImage.msg FC2OCSRarmResizedImage.msg
FC2OCSHeadLogPolarResizedImage.msg FC2OCSLarmLogPolarResizedImage.msg FC2OCSRarmLogPolarResizedImage.msg
FC2OCSDepthRegisteredResized.msg
FC2OCSCroppedPoints.msg
OCS2FCJointStateRiMove.msg
)
generate_messages(DEPENDENCIES std_msgs sensor_msgs jsk_network_tools jsk_interactive_marker)

catkin_package(
  CATKIN_DEPENDS std_msgs jsk_interactive_marker message_runtime
  )


install(DIRECTORY config jsk_pr2_image_transport
  jsk_pr2_joy jsk_pr2_lifelog jsk_pr2_move_base 	jsk_pr2_moveit
  jsk_pr2_sensors jsk_pr2_warning src
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

install(FILES install_pr1040_description.sh jsk_pr2.machine plugin.xml
  pr2.launch pr2_bringup.launch pr2_jsk_interactive.launch 	rviz.launch startup.app
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
