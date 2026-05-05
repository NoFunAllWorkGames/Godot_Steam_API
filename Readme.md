Godot Steam API
===============

As most games will utilize Steam, this uses the most popular Steamworks SDK for Godot  
Goal is to get familiar what is possible with Steamworks within Godot 
It's created using Steams Spacewar example game  

| Feature                        | Supported (AppID 480) | Implemented |
| :----------------------------- | :-------------------: | :---------- |
| **Steam Initialization**       |          ✅           | ✅          |
| **Leaderboards**               |          ✅           | ✅          |
| **Achievements**               |          ✅           | 🚧          |
| **Stats**                      |          ✅           | ❌          |
| **Rich Presence**              |          ✅           | ❌          |
| **Steam Overlay**              |          ✅           | ❌          |
| **Friends / Personas**         |          ✅           | ❌          |
| **Lobbies**                    |          ✅           | ❌          |
| **P2P Networking**             |          ✅           | ❌          |
| **Workshop**                   |          ❌           | ❌          |
| **Cloud Saves**                |          ❌           | ❌          |
| **DLC / In-App Purchases**     |          ❌           | ❌          |
| **Steam NetworkingSockets**    |          ❓           | ❌          |
| **Remote Play**                |          ❓           | ❌          |
| **User Authentication**        |          ❓           | ❌          |
| **Steam Input**                |          ❓           | ❌          |
| **Steam Utils**                |          ❓           | ❌          |
| **Steam Screenshots**          |          ❓           | ❌          |
| **Steam Music / Music Remote** |          ❓           | ❌          |
| **Steam Video**                |          ❓           | ❌          |
| **Steam HTML Surface**         |          ❓           | ❌          |
| **Steam Game Search**          |          ❓           | ❌          |
| **Steam Parties**              |          ❓           | ❌          |


Steam Initialization
--------------------

Uses the local Steam installation  
That means if you have steam installed, it will show your private account details  
It displays the initialization variables  

![Init Screenshot](Images/Init.jpg)

Leaderboard
-----------

Supports displaying of current Leaderboard entries  
Actually still lacks a way to update the players score via UI  

![Leaderboard Screenshot](Images/Leaderboard.jpg)