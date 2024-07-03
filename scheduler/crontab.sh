# Start container 1 on Monday at 00:00
0 0 * * 1 /path/to/start_container1.sh

# Stop container 1 on Wednesday at 23:59
59 23 * * 3 /path/to/stop_container1.sh

# Start container 2 on Thursday at 00:00
5 0 * * 4 /path/to/start_container2.sh

# Stop container 2 on Saturday at 23:59
59 23 * * 6 /path/to/stop_container2.sh
