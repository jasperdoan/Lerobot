sudo chmod 666 /dev/ttyACM0
sudo chmod 666 /dev/ttyACM1


=====================================================================


/dev/ttyACM1    --> Leader          --> 5V
lerobot-setup-motors \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM1

lerobot-calibrate \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM1 \
    --teleop.id=leader_arm

-------------------------------------------
NAME            |    MIN |    POS |    MAX
shoulder_pan    |    754 |   2019 |   3230
shoulder_lift   |    871 |    885 |   3271
elbow_flex      |    862 |   3054 |   3054
wrist_flex      |    829 |    835 |   3169
gripper         |   1903 |   1922 |   3135

Calibration saved to /home/jasper/.cache/huggingface/lerobot/calibration/teleoperators/so_leader/leader_arm.json


====================================================================


/dev/ttyACM0    --> Follower        --> 12V
lerobot-setup-motors \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0

lerobot-calibrate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM0 \
    --robot.id=follower_arm

-------------------------------------------
NAME            |    MIN |    POS |    MAX
shoulder_pan    |    884 |   2044 |   3320
shoulder_lift   |    756 |    808 |   3353
elbow_flex      |    868 |   3055 |   3061
wrist_flex      |    805 |   1985 |   3153
gripper         |   1899 |   1911 |   3363

Calibration saved to /home/jasper/.cache/huggingface/lerobot/calibration/robots/so_follower/follower_arm.json


====================================================================
Teleoperate:
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM1 \
    --robot.id=follower_arm \
    --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30, fourcc: "MJPG"}, wrist: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30, fourcc: "MJPG"}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM0 \
    --teleop.id=leader_arm \
    --display_data=true

====================================================================

Record:
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM1 \
    --robot.id=follower_arm \
    --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30, fourcc: "MJPG"}, wrist: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30, fourcc: "MJPG"}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM0 \
    --teleop.id=leader_arm \
    --display_data=true \
    --dataset.repo_id=so101/clean_table \
    --dataset.num_episodes=10 \
    --dataset.single_task="Pick up and move the cup to the marker" \
    --dataset.push_to_hub=false \
    --dataset.episode_time_s=60 \
    --dataset.reset_time_s=30


Resume:
lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM1 \
    --robot.id=follower_arm \
    --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30, fourcc: "MJPG"}, wrist: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30, fourcc: "MJPG"}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM0 \
    --teleop.id=leader_arm \
    --display_data=true \
    --dataset.repo_id=so101/clean_table \
    --dataset.num_episodes=8 \
    --dataset.single_task="Pick up and move the cup to the marker" \
    --dataset.push_to_hub=false \
    --dataset.episode_time_s=60 \
    --dataset.reset_time_s=30 \
    --resume=true


~/.cache/huggingface/lerobot/{repo-id}


Tasks:
- Pick up the pen and put it in the holder.




============================================

*p1: Task name
*p2: Episode time in seconds
*p3: Reset time in seconds
*p4: Number of episodes
*p5: Whether to resume from the last episode (optional, default: false)

Default Record: ./run.sh

Teleoperate only: ./run.sh "" "" "" "" teleop

Custom Task/Time: ./run.sh "Grab pens and place into pen holder" 15 15 10

Resume: ./run.sh "Grab pens and place into pen holder" 15 15 10 resume


=====================================================


Recommended 100-Episode Plan (Production Level):

    Episodes 1–20 (The Anchor): Same pen (e.g., Red), same starting spot, same holder spot. This builds the "base skill."

    Episodes 21–50 (Spatial Randomization): Move the starting position of the pen by 3–5cm every 2-3 episodes. Move the pen holder by 2cm every 5 episodes.

    Episodes 51–80 (Color/Object Swapping): Switch to the Blue and Black pens. Important: Do not change the position when you first swap colors so the model learns "Color doesn't change the physics of the pick."

    Episodes 81–100 (Orientation Variability): Rotate the pen (horizontal vs. vertical) so the gripper learns it needs to rotate 90° to grab it.

Episode Length & Multi-Pen Handling:

    One Episode = One Pen: Do not try to record picking all 3 pens in a single long episode yet. VLAs like GR00T N1.5 have a "temporal horizon" (usually 2–5 seconds of memory). If you do a 30-second multi-pen episode, the model gets "lost" after the first drop.

    Instruction: Use "Pick up the pen and put it in the holder." The model will learn to look for any pen. If you want it to pick all 3, you'll need to run the inference loop 3 times.


=====================================================

