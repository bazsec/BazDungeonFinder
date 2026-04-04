# BazDungeonFinder

A detached, always-visible LFG queue status bar for World of Warcraft — no more squinting at the tiny micro menu eyeball.

---

## What is BazDungeonFinder?

BazDungeonFinder gives you a proper queue status bar that appears automatically when you enter the LFG queue. It steals the animated eye from Blizzard's micro menu and places it on a rich status bar with live queue data — role fill status, wait times, dungeon name, and a group-found countdown.

Drag it anywhere on screen and always know exactly where your queue stands.

---

## Features

### Queue Status Bar
- Appears automatically when you join a dungeon or raid finder queue
- Fades in/out smoothly on queue start/end
- Shows **dungeon name**, **queue timer**, **average wait estimate**
- **Role fill indicators** — tank, healer, DPS counts with color-coded status
- **"Group Found!"** notification with green glow when ready
- Draggable and lockable — position it anywhere on screen

### Animated Eye
- Steals the LFG animated eye from Blizzard's micro menu
- Displayed prominently on the left side of the bar
- Micro menu is automatically resized to fill the gap

### Expandable Details Panel
- Click the chevron to expand a details panel below the bar
- **Group composition** — visual role slots showing filled positions
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

Open settings via `/bdf settings` or right-click the bar.

| Setting | Description |
|---------|-------------|
| Bar Width | Adjust bar width (200-500px) |
| Bar Opacity | Adjust bar transparency |
| Lock Position | Prevent the bar from being dragged |
| Auto Show/Hide | Automatically show when queued |
| Show Estimated Wait | Display the estimated wait time |
| Show Role Icons | Display your queued role icons |
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

## Part of the Baz Suite

BazDungeonFinder is part of the **Baz Suite** of addons:

- **[BazBars](https://www.curseforge.com/wow/addons/bazbars)** — Custom extra action bars
- **[BazLootNotifier](https://www.curseforge.com/wow/addons/bazlootnotifier)** — Animated loot popups
- **[BazDungeonFinder](https://www.curseforge.com/wow/addons/bazdungeonfinder)** — Detached LFG queue bar
- **[BazFlightZoom](https://www.curseforge.com/wow/addons/bazflightzoom)** — Auto zoom on flying mounts

---

## Compatibility

- **WoW Version:** Retail 12.0 (Midnight)
- **Dependencies:** None — completely standalone
- **Combat Safe:** Queue status updates work in and out of combat

---

## License

BazDungeonFinder is licensed under the **GNU General Public License v2** (GPL v2).
