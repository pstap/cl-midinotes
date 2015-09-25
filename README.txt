cl-midinotes is a tiny library for turning human readable music
notes into MIDI note numbers and frequencies.
"#" represents a sharp, and "b" represents a flat.

Example:
(cl-midinotes:note->midi "C#4") return 49
