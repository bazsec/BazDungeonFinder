# BazDungeonFinder Changelog

## 009 - Unified Profiles
- Profiles now managed centrally in BazCore settings
- Removed per-addon Profiles subcategory

## 007 - Audit Fixes
- Replaced BazDF global with BazCore:GetAddon() pattern
- Consolidated duplicated color constants between UI_Bar and UI_Details
- Removed unused instanceDeaths state variable
- Removed manual profile proxy (now auto-wired by BazCore)
- Category changed to "Baz Suite"

## 006
- Removed debug prints

## 005 - Instance Actions + Polish
- Teleport button in dungeon mode (teleport in/out of instance)
- Leave group button repurposed from leave queue X (with confirmation dialog)
- Bar stays in dungeon mode when teleported out (uses instance group check)
- Fixed LeaveParty API for Midnight (C_PartyInfo.LeaveParty)
- Fixed bar layout after exiting instance mode

## 004 - Dungeon Mode + Fixes
- Bar now switches to dungeon info mode when inside an instance
- Shows dungeon name, difficulty, boss progress, and duration timer
- Boss tracking via C_ScenarioInfo (live updates on kill)
- Eyeball tooltip shows Blizzard's native queue info on hover
- Added bar scale setting with resize handle (Edit Mode only)
- Eye tooltip toggle in settings
- Wait time now uses personal estimate matching Blizzard's tooltip format
- Live data refresh every second (role counts, wait times)
- Fixed bar not hiding when entering dungeons
- Fixed eye position after Edit Mode exit

## 003 - Instance Detection
- Bar hides when entering a dungeon/raid instance
- Added PLAYER_ENTERING_WORLD and LFG_COMPLETION_REWARD event handling

## 002 - BazCore Migration
- Migrated to BazCore framework (profiles, settings, slash commands)
- Full Edit Mode integration via BazCore (overlays, grid snapping, settings popup)
- All settings accessible from Edit Mode popup
- BazCore is now a required dependency
- Removed manual lock/unlock — use Edit Mode to reposition
- Added minimap button via BazCore

## 001
- Initial release
- Detached LFG queue status bar with animated eye
- Live role fill indicators, wait estimates, queue timer
- Expandable details panel with per-role wait bars
- Group found notification with countdown
- Auto show/hide on queue state change
- Draggable, lockable bar position
- Settings panel with appearance, behavior, and UI cleanup options
- Hide Bags Bar and Fade Micro Menu options
