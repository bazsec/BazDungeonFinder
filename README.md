<h1 align="center">BazDungeonFinder</h1>

<p align="center">
  <strong>Detached LFG queue status bar for World of Warcraft</strong><br/>
  Replaces the micro menu eyeball with a rich, always-visible queue display.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/WoW-12.0%20Midnight-blue" alt="WoW Version"/>
  <img src="https://img.shields.io/badge/License-GPL%20v2-green" alt="License"/>
  <img src="https://img.shields.io/badge/Version-005-orange" alt="Version"/>
</p>

---

## What is BazDungeonFinder?

BazDungeonFinder gives you a detached, draggable queue status bar that appears automatically when you enter the LFG queue. It steals the animated eye from Blizzard's micro menu and places it on a proper status bar with live queue data — role fill status, wait times, dungeon name, and a group-found countdown.

No more squinting at the tiny micro menu eyeball to check your queue.

---

## Features

### Queue Status Bar
- Appears automatically when you join a dungeon or raid finder queue
- Fades in/out smoothly on queue start/end
- Shows **dungeon name**, **queue timer**, **average wait estimate**
- **Role fill indicators** — tank, healer, DPS counts with color-coded status (green = filled)
- **"Group Found!"** notification with green glow when a group is ready
- Draggable and lockable — position it anywhere on screen
- Right-click context menu for quick settings access

### Animated Eye
- Steals the LFG animated eye from Blizzard's micro menu
- Displayed prominently on the left side of the bar
- Micro menu is automatically resized to fill the gap

### Expandable Details Panel
- Click the chevron to expand a details panel below the bar
- **Group composition** — visual role slots showing which roles are filled
- **Dungeon info** — name and type (Dungeon / Raid Finder)
- **Per-role wait time bars** — tank, healer, and DPS estimated waits with progress bars
- **Proposal countdown** — green progress bar when a group is found

### Leave Queue
- Red X button to instantly leave the queue
- No need to dig through the LFG UI

### UI Cleanup Options
- **Hide Bags Bar** — removes the bag slot buttons from the UI
- **Fade Micro Menu** — hides the micro menu until you mouse over it

---

## Settings

Open settings via `/bdf settings` or right-click the bar → Settings.

### Appearance
| Setting | Description |
|---------|-------------|
| Bar Width | Adjust bar width (200-500px) |
| Bar Opacity | Adjust bar transparency (30-100%) |

### Behavior
| Setting | Description |
|---------|-------------|
| Lock Position | Prevent the bar from being dragged |
| Auto Show/Hide | Automatically show when queued, hide when not |

### Display
| Setting | Description |
|---------|-------------|
| Show Estimated Wait | Display the estimated wait time |
| Show Role Icons | Display your queued role icons |

### UI Elements
| Setting | Description |
|---------|-------------|
| Hide Bags Bar | Hide the bag slot buttons (requires reload) |
| Fade Micro Menu | Hide the micro menu until hovered (requires reload) |

---

## Slash Commands

| Command | Description |
|---------|-------------|
| `/bdf` | Show all commands |
| `/bdf lock` | Lock bar position |
| `/bdf unlock` | Unlock bar position |
| `/bdf reset` | Reset bar position |
| `/bdf settings` | Open settings panel |
| `/bdf show` | Show the bar |
| `/bdf hide` | Hide the bar |

---

## Installation

### CurseForge / WoW Addon Manager
Search for **BazDungeonFinder** in your addon manager of choice.

### Manual Installation
1. Download the latest release
2. Extract to `World of Warcraft/_retail_/Interface/AddOns/BazDungeonFinder/`
3. Restart WoW or `/reload`

---

## Compatibility

| | |
|---|---|
| **WoW Version** | Retail 12.0.1 (Midnight) |
| **Dependencies** | None |
| **Standalone** | No external libraries required |

---

## License

BazDungeonFinder is licensed under the [GNU General Public License v2](LICENSE) (GPL v2).

---

<p align="center">
  <sub>Built by <strong>Baz4k</strong></sub>
</p>
