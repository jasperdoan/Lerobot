#!/bin/bash

# --- FIXED CONFIGURATION ---
ROBOT_TYPE="so101_follower"
FOLLOWER_PORT="/dev/ttyACM0"
FOLLOWER_ID="follower_arm"
LEADER_TYPE="so101_leader"
LEADER_PORT="/dev/ttyACM1"
LEADER_ID="leader_arm"
CAMERAS='{ front: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30, fourcc: "MJPG"}, wrist: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30, fourcc: "MJPG"}}'
REPO_ID="so101/handover"

# --- DEFAULT DYNAMIC VALUES ---
TASK=${1:-"Grab and put down the screwdriver on the right side of the table"}
TIME=${2:-60}
RESET=${3:-30}
NUM_EPISODES=${4:-10}

case "$5" in
    teleop)
        lerobot-teleoperate \
            --robot.type=$ROBOT_TYPE --robot.port=$FOLLOWER_PORT --robot.id=$FOLLOWER_ID \
            --robot.cameras="$CAMERAS" \
            --teleop.type=$LEADER_TYPE --teleop.port=$LEADER_PORT --teleop.id=$LEADER_ID \
            --display_data=true
        ;;
    resume)
        lerobot-record \
            --robot.type=$ROBOT_TYPE --robot.port=$FOLLOWER_PORT --robot.id=$FOLLOWER_ID \
            --robot.cameras="$CAMERAS" \
            --teleop.type=$LEADER_TYPE --teleop.port=$LEADER_PORT --teleop.id=$LEADER_ID \
            --display_data=true \
            --dataset.repo_id=$REPO_ID \
            --dataset.num_episodes=$NUM_EPISODES \
            --dataset.single_task="$TASK" \
            --dataset.push_to_hub=false \
            --dataset.episode_time_s=$TIME \
            --dataset.reset_time_s=$RESET \
            --resume=true
        ;;
    *) # Default action is record
        lerobot-record \
            --robot.type=$ROBOT_TYPE --robot.port=$FOLLOWER_PORT --robot.id=$FOLLOWER_ID \
            --robot.cameras="$CAMERAS" \
            --teleop.type=$LEADER_TYPE --teleop.port=$LEADER_PORT --teleop.id=$LEADER_ID \
            --display_data=true \
            --dataset.repo_id=$REPO_ID \
            --dataset.num_episodes=$NUM_EPISODES \
            --dataset.single_task="$TASK" \
            --dataset.push_to_hub=false \
            --dataset.episode_time_s=$TIME \
            --dataset.reset_time_s=$RESET
        ;;
esac