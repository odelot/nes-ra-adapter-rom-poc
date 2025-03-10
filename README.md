# nes-ra-adapter-rom-poc
Proof of Concept (PoC) for a NES ROM that would interfacing with a microcontroller

## Overview
This project tried to explore the concept of creating a NES ROM that communicates with a microcontroller. The initial approach involved using an STM32 Black Pill to simulate a NES program mask ROM, enabling serial communication with other microcontrollers. These microcontrollers could modify a dedicated `microcontroller.dat` area, allowing the NES program to query and display data on-screen in real time.

The idea was to integrate this with the **NES RA Adapter**, a device designed to bring **RetroAchievements** to real NES consoles. More details about the adapter can be found [here](https://retroachievements.org/viewtopic.php?t=29198).

## Project Status
**This approach was ultimately abandoned** in favor of a more practical solution. Instead of interfacing with the user via the television (running a NES program before playing a game), I opted for a **tiny LCD screen**. This allows real-time achievement notifications and other information to be displayed **during gameplay**, such as the image of an unlocked achievement.

You can download [cart.nes](https://github.com/odelot/nes-firmware-poc/blob/main/cart.nes) and play on your favorite emulator. It is very very simple. Here it is running on emulator and how this user experience ended up running on the tiny LCD:

|  display on TV, running on NES | display on Tiny LCD, running on microcontroller |
| ------------- | ------------- |
| ![alt-text](https://github.com/odelot/nes-firmware-poc/blob/main/images/telaNes.gif)  | ![alt-text](https://github.com/odelot/nes-firmware-poc/blob/main/images/telaAdapter.gif)  |

## Purpose of This Repository
Even though this idea was not pursued further, I’m sharing this project as a **record of the different approaches** I explored during the adapter’s development. As often happens in projects, some paths are dropped in favor of better alternatives, but they still hold value as learning artifacts.

Hope this helps anyone working on similar ideas! ^.^
