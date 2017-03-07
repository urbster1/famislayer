----------------------------------------------------
FAMISLAYER v6.66
Copyright 2014 Dan Vujeva
For more information, visit: http://www.heavyw8bit.com
Shoutouts: Warper Party, Outback Nexus, IO Chip Crew
Credits: CHR file and some variables & subroutines are from Vegaplay by No Carrier (http://www.no-carrier.com)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses

----------------------------------------------------

FamiSlayer is a slave player for NSF files exported from FamiTracker.
Key presses on controller 2 act as the clock input, and will run the next step of the NSF.

Controller 1:
A      Play/Pause
B      Stop
UP     Increase Song Number
DOWN   Decrease Song Number
START  *Restart Song from begining
RIGHT  *Fast Forward (Jumps to the begining of the next frame)
LEFT   *Rewind (Resets back to the begining of the current frame)

*Designed to work with the Famitracker NSF Driver.
 
Since some of the code is derived from Vegaplay, compling a ROM with your own NSF file would work the same way.
 - Enter the LOAD, PLAY and INIT addresses for your NSF in FamiSlayer.asm
 - Remove the NSF header
 - Rename file to temp.nsf and compile.
 - Rock out w/ your clock out!

-------------------------
NSF LSDJ Sync
-------------------------
To sync the NSF with LSDJ:
 - LSDJ, set sync = nano
 - FamiTracker, set the speed = 3 and tempo = 150