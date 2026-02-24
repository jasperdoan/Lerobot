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

Default Record: `./run.sh`

Teleoperate only: `./run.sh "" "" "" "" teleop`

Custom Task/Time: `./run.sh "Grab pen and place into pen holder" 15 15 10`

Resume: `./run.sh "Grab pen and place into pen holder" 15 15 10 resume`


=====================================================


Recommended 100-Episode Plan (Production Level):


### The Coordinate System & Constraints
*   **Safe Zone:** Radius 7" to 14" from base.
*   **Dead Zone:** 0" to 6" from base (inaccessible).
*   **Holder Default:** (0, 14) — *Note: I moved this from 16 to 14. At 16", the SO-101 arm is at "full stretch." Servos often jitter or lose torque at 100% extension, which creates "noisy" data. 14" is the "Production Edge."*
*   **Neutral Position:** (0, 8) at 4" height. Always return here before stopping recording.

### The 100-Episode Production Plan

| Episode # | Pen Color | Pen (X, Y) | Holder (X, Y) | Pen Orientation | Key Lesson for Model |
|:---|:---|:---|:---|:---|:---|
| **1-10** | Red | (0, 9) | (0, 14) | Vertical (0°) | **The Anchor:** Perfecting the motor "pathway." |
| **11-20** | Red | (0, 9) | (0, 14) | Vertical (0°) | **Consistency:** Building high confidence in the base task. |
| **21-25** | Red | (-6, 8) | (0, 14) | Vertical (0°) | **Left Reach:** Solving for negative X coordinates. |
| **26-30** | Red | (6, 8) | (0, 14) | Vertical (0°) | **Right Reach:** Solving for positive X coordinates. |
| **31-35** | Red | (8, 2) | (0, 14) | Vertical (0°) | **Far Side Reach:** Pen is close to range. |
| **36-40** | Red | (-8, 2) | (0, 14) | Vertical (0°) | **Far Side Reach:** Pen is close to range. |
| **41-45** | Red | (0, 10) | (-6, 12) | Vertical (0°) | **Moving Target:** Holder moves to the left. |
| **46-50** | Red | (10, 8) | (6, 12) | Vertical (0°) | **Extreme Edge:** Far right pen to right-shifted holder. |
| **51-55** | Blue | (0, 10) | (0, 14) | Vertical (0°) | **Color Swap:** Identity generalization (Blue). |
| **56-60** | Blue | (-7, 9) | (5, 13) | Vertical (0°) | **Spatial + Color:** Cross-body reach with new color. |
| **61-65** | Black | (0, 10) | (0, 14) | Vertical (0°) | **Color Swap:** Identity generalization (Black). |
| **66-70** | Black | (7, 9) | (-5, 13) | Vertical (0°) | **Spatial + Color:** Cross-body reach with new color. |
| **71-75** | Any | (-8, 10) | (0, 14) | **Horizontal (90°)**| **Edge Rotation:** Forced 90° wrist turn at a far-left angle. |
| **76-80** | Any | (8, 10) | (0, 14) | **Horizontal (90°)**| **Edge Rotation:** Forced 90° wrist turn at a far-right angle. |
| **81-85** | Any | (0, 10) | (0, 14) | **Diagonal (45°)** | **Rotation:** Gripper must tilt 45° to match pen. |
| **86-90** | Any | (0, 10) | (0, 14) | **Horizontal (90°)**| **Rotation:** Gripper must tilt 90° (Full Side Grab). |
| **91-95** | Any | Random* | (0, 14) | **Diagonal (-45°)**| **Rotation:** Counter-rotation reach. |
| **96-100**| Any | Random* | Random* | **Full Random** | **Production Test:** Mix all variables. |

*\*Random: Pick any coordinate within the 7"-14" radial safe zone.*

---

### How to end every episode:
1.  Drop pen in holder.
2.  Open gripper fully.
3.  Lift arm vertically 3 inches (Clearance).
4.  Move arm to **(0, 8)**.
5.  **Stop recording.**
