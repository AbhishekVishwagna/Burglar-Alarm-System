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
