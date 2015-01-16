# A message from FC to OSC.
# There is are several limitations
# 1. no nested fields is allowed.
# 2. no variable length array is allowed.
# 3. string is not supported.
# 4. duration and time are not supported.

uint8[17] joint_angles
uint8 state
