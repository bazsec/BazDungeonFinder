> **Warning: Requires [BazCore](https://www.curseforge.com/wow/addons/bazcore).** If you use the CurseForge app, it will be installed automatically. Manual users must install BazCore separately.

# BazDungeonFinder

![WoW](https://img.shields.io/badge/WoW-12.0_Midnight-blue) ![License](https://img.shields.io/badge/License-GPL_v2-green) ![Version](https://img.shields.io/github/v/tag/bazsec/BazDungeonFinder?label=Version&color=orange)

A detached LFG queue status bar with rich dungeon and group info.

BazDungeonFinder gives you a dedicated, always-visible queue status bar that shows everything you need to know about your current dungeon queue - role fill status, wait estimates, queue timer, dungeon name, and instance details. When a group is found, the bar transforms into a proposal view. Inside a dungeon, it shows instance info with a teleport in/out button.

> **Note:** A widget version of Dungeon Finder is also available in [BazWidgets](https://www.curseforge.com/wow/addons/bazwidgets) for users who prefer it docked inside [BazWidgetDrawers](https://www.curseforge.com/wow/addons/bazwidgetdrawers). The widget version is dormant - it only appears when you're queued.

***

## Features

*   **Queue status bar** with role fill indicators (tank / healer / DPS)
*   **Wait time estimates** - your estimated wait and average wait
*   **Live queue timer** showing how long you've been in queue
*   **Dungeon name** and instance type display
*   **Group Found** proposal view when a group is ready
*   **Instance mode** with dungeon info and teleport in/out button
*   **BNC integration** - queue events push toasts through BazNotificationCenter when installed
*   **Configurable** via BazCore settings panel
*   **Profile support** via BazCore

***

## Slash Commands

| Command | Description |
| --- | --- |
| `/bdf` | Open settings panel |

***

## Compatibility

*   **WoW Version:** Retail 12.0 (Midnight)
*   **Combat Safe:** No secure frame manipulation
*   **BazNotificationCenter:** Queue events push toasts when BNC is installed

***

## Dependencies

**Required:**

*   [BazCore](https://www.curseforge.com/wow/addons/bazcore) - shared framework for Baz Suite addons

**Optional:**

*   [BazNotificationCenter](https://www.curseforge.com/wow/addons/baznotificationcenter) - queue event toasts

***

## Part of the Baz Suite

BazDungeonFinder is part of the **Baz Suite** of addons, all built on the [BazCore](https://www.curseforge.com/wow/addons/bazcore) framework:

*   **[BazBars](https://www.curseforge.com/wow/addons/bazbars)** - Custom extra action bars
*   **[BazWidgetDrawers](https://www.curseforge.com/wow/addons/bazwidgetdrawers)** - Slide-out widget drawer
*   **[BazWidgets](https://www.curseforge.com/wow/addons/bazwidgets)** - Widget pack for BazWidgetDrawers
*   **[BazNotificationCenter](https://www.curseforge.com/wow/addons/baznotificationcenter)** - Toast notification system
*   **[BazLootNotifier](https://www.curseforge.com/wow/addons/bazlootnotifier)** - Animated loot popups
*   **[BazFlightZoom](https://www.curseforge.com/wow/addons/bazflightzoom)** - Auto zoom on flying mounts
*   **[BazMap](https://www.curseforge.com/wow/addons/bazmap)** - Resizable map and quest log window
*   **[BazMapPortals](https://www.curseforge.com/wow/addons/bazmapportals)** - Mage portal/teleport map pins

***

## License

BazDungeonFinder is licensed under the **GNU General Public License v2** (GPL v2).
