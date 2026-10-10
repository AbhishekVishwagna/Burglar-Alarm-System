# Burglar Alarm System
---

## Project Description

This is a Burglar Alarm system project on the ARM Cortex-A9 (DE1-SoC) with real_time LCD Display, hardware button input, a countdown timer, audio feedback.
The system replicates a real security alarm with four states - Disarmed, Armed, Triggered, and Lockout. These are controlled by a state machine running on the DE1-SoC Board. A four button press PIN sequence is used to disarm or disable the system, with a lockout activating after three consecutive wrong attempts. The system will provide a visual feedback on the LT24 LCD display and also on the seven segment displays onboard the DE1-SoC Board.

---

## System design

The Burglar Alarm System is implemented on the DE1-SoC platform, utilizing a hardware-software co-design approach. The core logic is governed by a synchronous Finite State Machine (FSM), which ensures reliable transitions between security states based on user input and sensor data.

---
### Functional Block Diagram

The system is partitioned into several dedicated modules to ensure modularity and ease of debugging:

*   **State Control Logic (FSM):** The main part of the system. It handles the transition between the following states:
    *   `DISARMED`: System is idle; waiting for the correct arming sequence.
    *   `ARMING`: Provides a grace period for the user to exit the premises.
    *   `ARMED`: Actively monitoring sensor inputs (switches/GPIO).
    *   `TRIGGERED`: Alarm is active; requires the correct PIN to reset.
*   **Pin Verification Module:** A comparator circuit that validates the input from the toggle switches against a hardcoded or programmable security key.
*   **LCD Interface Controller:** A driver module that translates system state data into ASCII characters for real-time status updates on the **LT24** Display.
*   **User Interface (I/O Handler):**
    *   **Inputs:** Push-buttons (`KEYs`) for PIN entry and Toggle Switches (`SWs`) for reset.
    *   **Outputs:** Hex Displays for countdowns and LEDs for visual status indicators.

```
IDLE ──(SW0 up)──► ARMED ──(SW1 flipped)──► TRIGGERED ──(5s) ──────►  PIN_ENTRY
                      ▲                                               │      │
                      │                                               │    3 wrong / 60s
                      │                                               │      │
                      └──────────────── SUCCESS ◄─────────────────────┘   LOCKOUT
                                                                             │ (30s)
                                                                             ▼
                                                                            IDLE
```

 #
 
### Design Methodology

*   **Hardware Description:** The peripheral controllers and the FSM logic are authored in **Verilog HDL**, synthesized using **Intel Quartus Prime lite**.
*   **Clock Management:** A clock divider module is employed to step down the 50MHz onboard oscillator to a human-readable frequency for the alarm delay and LED blinking patterns.
*   **Synchronization:** All asynchronous inputs from buttons and switches are passed through a **debouncing circuit** to prevent false triggers.

#

### State Transition

- **IDLE** : Nothing is happening. LCD shows a blue "LOCK THE SYSTEM" screen with an unlocked padlock.
 
- **ARMED** : System is watching for the sensor. LCD shows green "LOCKED". Flip SW[0] back down to return to idle.
 
- **TRIGGERED** : Motion detected. LCD goes red with "ALARM / TRIGGERED". The 5-second countdown starts on HEX0/HEX1. After 5 seconds the system moves to PIN entry automatically.
 
- **PIN_ENTRY** : User has 60 seconds and 3 attempts to enter the PIN. The 60-second countdown runs on the 7-seg displays. LCD shows "ENTER THE PIN" on the first attempt. After each wrong attempt the screen changes to show how many attempts are left.
 
- **SUCCESS** : Correct PIN entered. LCD shows green "PIN ENTERED / SUCCESSFULLY" for 2 seconds, then the system goes back to ARMED (or IDLE if SW[0] was flipped down).
 
- **LOCKOUT** : Too many wrong attempts or timed out. LCD shows red "WRONG PIN / SYSTEM LOCKED". Locked for 30 seconds then resets to IDLE.

#

## Hardware pin setup
 
| Input | Board Pin | What it does |
|---|---|---|
| SW[0] | AB12 | Arm switch — flip up to arm the system |
| SW[1] | AC12 | Sensor trigger — flip up to simulate motion detection |
| KEY[0] | AA14 | System reset (hold down) |
| KEY[1] | AA15 | PIN button 1 |
| KEY[2] | W15 | PIN button 2 |
| KEY[3] | Y16 | PIN button 3 |
 

#

## PIN entry
 
The correct sequence is: **KEY2 → KEY3 → KEY1**
 
Each attempt requires exactly 3 button presses. The system only decides if the attempt is right or wrong after the third press — pressing a wrong button on the first press doesn't immediately count as a failed attempt, you still need to complete all 3 presses. This means you get the full 9 button presses across 3 attempts before the system locks out.
 
The buttons are debounced (20ms counter at 50MHz) so each physical press produces exactly one pulse regardless of how long you hold the button.

#

 ## LCD screens
 
| State | Screen | Colour |
|---|---|---|
| IDLE | "LOCK THE  SYSTEM" + unlocked padlock | Blue |
| ARMED | "LOCKED" + padlock icon | Green |
| TRIGGERED | "ALARM  TRIGGERED" | Red |
| PIN_ENTRY  | "ENTER THE  PIN" | Blue |
| PIN_ENTRY  | "WRONG PIN  ATTEMPTS: 2" | Red |
| PIN_ENTRY  | "WRONG PIN  ATTEMPTS: 1" | Red |
| SUCCESS | "PIN ENTERED  SUCCESSFULLY" | Green |
| LOCKOUT | "WRONG PIN  SYSTEM LOCKED" | Red |
 
---
