# Jungle Jump - Part 2

The finished two-level Godot game: level01 transitions to level02, with solid crate obstacles, collectibles, enemies, ladders, moving platforms, checkpoints, and title/pause/retry/victory screens.

## Browser-ready download

[Download Jungle-Jump-2-Web.zip](web-build/Jungle-Jump-2-Web.zip?raw=true)

Upload that ZIP directly to itch.io as an HTML game and select **This file will be played in the browser**. Set an initial embed size of **960 x 540** and enable fullscreen. The archive contains index.html at its root and all required JavaScript, WebAssembly, and game data.

For another web host, extract the ZIP and serve its files over HTTP/HTTPS. Do not open index.html directly from disk.

## Edit or play in Godot

Import project.godot into Godot 4.7.2 and press F5. See [GAME_GUIDE.md](GAME_GUIDE.md) for project structure, controls, and export instructions.

- A/D or Left/Right: move
- Space: jump / double jump
- W/S or Up/Down: climb
- Escape: pause
- R: retry level
- M: mute

Validation: 79 interaction checks and both automated route tests pass. The project uses the Compatibility renderer and a non-threaded Web export.

This is the Part 2 repository. Part 1 remains in jungle-jump-1.
