# 🎮 8086 Assembly Quiz Game

Ready for a quick quiz? This 8086 assembly program asks three general-knowledge questions, gives feedback after each answer, and reports your final score.

## ▶️ Play a round

Open `quiz_game.asm` in EMU8086, assemble it, and run it in the emulator. Press **A** or **B** for each question.

```text
Q1: Capital of France? (A: Paris  B: Rome): A
 -> Correct!
Q2: Red planet in space? (A: Venus  B: Mars): B
 -> Correct!
Q3: Largest ocean on Earth? (A: Pacific  B: Atlantic): A
 -> Correct!

Final Score: 3 / 3
 -> Great job! You passed!
```

## ✨ What’s included

- Three multiple-choice questions
- Uppercase and lowercase A/B input
- Immediate correct-or-wrong feedback
- Final score out of 3
- Pass message for scores of **2 or more**

## 🧩 Try these challenges

Run the quiz with each answer sequence and see what happens:

| Answers | What to look for |
|---|---|
| `A, B, A` | A perfect score |
| `A, B, B` | The pass threshold |
| `B, B, B` | A score below the threshold |
| `a, b, a` | Lowercase input |

<details>
<summary>🔎 Reveal the answer key</summary>

The correct answers are **A, B, A**.

</details>

## ⚙️ How it works

The program stores question addresses and correct answers in arrays. It loops through the questions, reads each key using DOS `INT 21h`, compares it with the answer, and updates the score. BIOS `INT 10h` clears the text screen at startup.

## 🛠️ Tools and platform

- 8086 assembly language
- EMU8086
- DOS `INT 21h` keyboard and text I/O
- BIOS `INT 10h` text mode

This program is intended for EMU8086 or a compatible 8086 DOS environment.

## 📁 Files

- `quiz_game.asm` — assembly source code
- `README.md` — project overview and run instructions
