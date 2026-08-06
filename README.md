# desktop-pet
An interactive pixel-art that lives on your Windows desktop. Pet the cat, collect hearts, keep it company while you work.
Built with **Godot 4 (GDScript)**, running as a transparent, borderless, always-on-top window.

## Features
♡ Pet the cat to earn hearts.
♡ Context-aware speech bubbles.
♡ Multiple cat skins (selectable from the panel).
♡ Transparent, always-on-top desktop window.
♡ Persistent progress (hearts, selected cat, stats).

## Animations
| Animation | Trigger | Frames | Loop |
|-----------|-----------|-----------|-----------|
| Idle   | Default, without interaction   | 4   | Yes  |
| Petting   | Mouse held/clicked on the cat   | 6   | No   |
| Happy   | Without interaction   | 3  | No  |
| Yawn   | X seconds without interaction   | 7  | No  |
| Sleeping   | X minutes without interaction   | 5   | No  |
| Glitched   | 11 hearts reached, without interaction, every x minutes   | 3   | No  |

## Dialogue system
| Animation state | Dialogue type | Example |
|-----------|-----------|-----------|
| Idle   | Normal state dialogue   | "Sleep well tonight!"   |
| Petting   | Affection dialogue   | "Purrrr..."   |
| Sleeping   | Sleep dialogue   | "Zzz..."   |
| Glitched   | Sleep dialogue   | "Where is my d3v?"   |


Phrases live in *json link*, grouped by type, so new lines can be added without touching GDScript.

## Cat selection panel: how does it work?

### Data persistence
Progress is saved locally via *json link*.

## Project structure

## How to run the project: instructions

## Roadmap / Milestones
[ ] All cats tilesets.
[x] UI tilesets.
[x] All animations.
[x] Json: dialogue type.
[ ] Heart counter + persistence.
[x] Functional cat selection panel.
[ ] Sound effects.

## Credits and license
♡ Pixel art: libresprite.
♡ Font:
♡ Engine: Godot 4.
♡ License:
