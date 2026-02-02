# Retrieve Hardware UUID (more commonly used for Mac identification)
echo "Hardware UUID:"
system_profiler SPHardwareDataType | grep "Hardware UUID" | awk '{print $3}'
