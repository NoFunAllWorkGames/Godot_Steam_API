Godot Steam API
---------------


Steam Initialization
--------------------





I ordered in order I would approach the topics

| Feature                    | Supported (AppID 480) | Limitations / Technical Notes                                       |
| :------------------------- | :-------------------: | :------------------------------------------------------------------ |
| **Steam Initialization**   |          ✅           | Requires Steam Client running; fails if user is offline.            |
| **Leaderboards**           |          ✅           | Shared globally; stats are frequently reset or corrupted by others. |
| **Achievements**           |          ✅           | Triggers successfully but stores data under the SpaceWar AppID.     |
| **Rich Presence**          |          ✅           | Allows setting custom status strings (e.g., "In Main Menu").        |
| **Stats**                  |          ✅           | Standard integer/float stats work for the current session.          |
| **Steam Overlay**          |          ✅           | Functions fully; displays user as playing "SpaceWar".               |
| **Friends / Personas**     |          ✅           | Can retrieve names, avatars, and status of existing friends.        |
| **Lobbies**                |          ✅           | Functionally messy; you will see lobbies from all global testers.   |
| **P2P Networking**         |          ✅           | Steam NetworkingSockets and Relay function for data transfer.       |
| **Workshop**               |          ❌           | Requires unique AppID and configured Steamworks dashboard.          |
| **Cloud Saves**            |          ❌           | Requires specific file path configuration in the Steam backend.     |
| **DLC / In-App Purchases** |          ❌           | Microtransactions require a verified merchant account and AppID.    |
