# AIM-Trainer
A quick and dirty AIM trainer made in autohotkey. 
#
![image](https://github.com/user-attachments/assets/4b2c7866-aa5f-450f-864a-194e6db8f1dd)
#
This is a fully playable Aim Trainer that you can use on any machine with Autohotkey installed, or with any Windows based machine.
- I have included a .AHK version of the file to utilize on any system with Autohotkey installed.
- I have included a .exe version of the file to utilize with any version of Windows (probably XP or later).
- You only need one file.
#
There are five difficulty modes. These dictate how fast the targets despawn, and result in a higher score.
1. Very Hard: 500 ms
2. Hard: 1000 ms
3. Normal: 1500 ms
4. Easy: 2000 ms
5. Very Easy 2500 ms
#
Stats:
1. Remaining: "x" seconds. The time you have left for the round. This is always 60 seconds (for now).
2. Hits: How many targets you have hit.
3. Miss: How many times you missed the target.
4. Deaths: How many targets have despawned (simulates getting hit in an FPS title).
5. Accuracy: The calculated accuracy of your collective attempts (deaths don't count).
#
How to Play:
1. Just press the target to begin. Then keep hitting it. That's it really.
#
Results:
1. Score: The calculated score of the round. Window Size, Difficulty, Accuracy, Hits and Deaths all play a role.
2. Targets/s: Calculates how fast you were at hitting the targets per second.
#
Score Formula:
- Score = ((Window H + Window W) / 10) * (Hits * Accuracy) / Difficulty Modifier
- Difficulty Modifier = [500, 1000, 1500, 2000, 2500]
- Death Modifier = (Deaths * 3)/100
- Death Modifier = Score * Death Modifier
- Final Score Calculation = Score - Death Modifier

Example:
- Input:
- Score = ((1920 + 1080)/10) * (50 * 95) / 1500

Calculations:
- Score = 300 * 4750 / 1500
- Score = 950
- Deaths = 3
- Death Modifier = (3 * 3)/100
- Death Modifier = 9%
- Death Modifier = 950 * 0.09
- Final score = 950 - 85.5

Result:
- Final Score = 865
