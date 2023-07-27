# golden-sun-encounter-notes-overlay

Golden Sun practice tool: BizHawk Lua script that reads a notes CSV file and displays directives for each party member during an encounter

## Features

- Loads CSV files you can edit with your favorite spreadsheet program
- Automatically downloads notes you can use if you don't have any
- Allocates space for key words for each party member, as well as a general "extra" line of information
- Aligns notes to party member number whatever order they happen to be in (1 is always Isaac)
- Supports reverse encounters and adjusts targeting numbers appropriately
- Bugs

## Usage

Load `gs-encounter-notes-overlay.lua` from BizHawk 2.8's Lua Console while playing Golden Sun.

The `gs-encounter-notes.csv` file in the same folder, will drive the information displayed on-screen.
If the file does not exist, one will be downloaded automatically.

This has not been tested with any other emulator version.

This has not been tested with Golden Sun: The Lost Age, but support will come.

## Demo

https://github.com/akdb/golden-sun-encounter-notes-overlay/assets/20408541/8afa1b20-861d-465e-888c-5ae2a297fae6

## Notes Format

Comma-separated-values.
The first row, denoting the header, is key.
It does not matter what order the columns are in, but the following columns should be defined:

- `encounterKey` - Stores a set of enemies based on name (without numbers), comma separated e.g. `"Gnome,Gnome,Troll"`.
The system automatically can associate the reverse encounter to the correct key and adjust accordingly.
- `1` - Isaac's action. The first word is anything (but should be relatively short, 10 characters is probably too many to fit in the space available).
The second (optional) word is a targeting number denoting the 1-based enemy number from the left. e.g. `2` refers to the middle enemy in a group of 3.
- `2` - Garet's action, like above
- `3` - Ivan's action, like above
- `4` - Mia's action, like above
- `extra` - Any other stuff that doesn't fit but should be displayed on-screen
- `fileDescription` - Not actually associated with the encounter but will be text printed to the Lua console when the notes are loaded

Other columns are effectively ignored.

### Example

```text
area,encounterKey,4,1,2,3,extra,fileDescription
02 imil,"Gnome,Gnome,Gnome,Gnome",,ramses 2,atk 4,ray 2,T2:ray
```

## Special Thanks

- Thanks to those who taught me, directly or indirectly, about the internals of Golden Sun and helped solve certain challenges here
  - Plexa
  - Raphi
  - Salanewt
  - Tea
  - zadeta656
- Thanks to ollie for putting together an amazing Golden Sun encounter notes spreadsheet resource that helped inform and inspire me

## License

Copyright (C) 2023 Justin Schwartz, except where otherwise noted.

This code is licensed under the [MIT License](LICENSE).
