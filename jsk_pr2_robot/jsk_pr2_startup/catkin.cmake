cmake_minimum_required(VERSION 2.8.3)
project(jsk_pr2_startup)
find_package(catkin REQUIRED COMPONENTS message_generation sensor_msgs)

add_message_files(FILES FC2OCS.msg FC2OCSLargeData.msg OCS2FC.msg OCS2FCLargeData.msg)
generate_messages(DEPENDENCIES sensor_msgs)

catkin_package(
  CATKIN_DEPENDS message_runtime
  )

install(DIRECTORY config jsk_pr2_image_transport
  jsk_pr2_joy jsk_pr2_lifelog jsk_pr2_move_base 	jsk_pr2_moveit
  jsk_pr2_sensors jsk_pr2_warning src
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

install(FILES install_pr1040_description.sh jsk_pr2.machine plugin.xml
  pr2.launch pr2_bringup.launch pr2_jsk_interactive.launch 	rviz.launch startup.app
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
