#  yadve - yet another distributed video encoder

This is a Set of Scripts based on "dve - the distributed video encoder", but without using parallel or using ssh to start Workers on different Hosts.

Script yadve-master
 - Grabs the ffmpeg options or uses Default values
 - Creates the files needed by the workers
 - Create the Chunk Files

Script yadve-worker
 - Does the encoding

Script yadve-waiter
 - Lets the master wait until the last encoding is finished

Script yadve-merger
 - Merges the Junks to the encoded target file

With this Scripts, the encoding can be startet on several hosts.
Also different output container format is possible. Example: Inputfile is mkv, Outputfile is mp4.
Just specify the Suffix.

## Usage

The directory where the Scripts are stored is the working directory.
In here all temp. Files and the encoded File will be stored!
Be sure to have enough Space.

When just starting yadve-master, the complete encoding will be done only on the local host.

Usage for Master Host:
	usage: ./yadve-master [options] filename

	This script breaks a video file up into chunks and encodes them.
	
	OPTIONS:
    	-h  this help message.
    	-t  rough length of individual video chunks, in seconds. (default=120)
    	-o  encoding options. (default=-map 0 -c:v libx265 -pix_fmt yuv420p10le -preset fast -x265-params crf=20 -c:a copy)
    	-s  output file suffix. Must be a Multimedia File Format like mkv,mp4,avi etc. (default=new.mkv)
    	-q  video encoding quality, shortcut to use default encoding options with
        	a different CRF. (default=20)
    	-v  verbose job output. (default=false)
	
Example:
	yadve-master video.mkv

Or:
	yadve-master -o"-acodec copy -map 0 -vcodec libx265 -x265-params crf=16:colorprim=bt2020:transfer=smpte-st-2084:colormatrix=bt2020nc" -s"new.mp4" video.mkv

Usage on Worker Host (no Options needed):
	yadve-worker

	This script starts enconding on additional host.

The Workers can be startet before the Master has finished the chunks.


## Prerequisites

The Master Host must share the working Directory with NFS Server or Samba Server and the Worker (Client) Hosts must have mounted the Share.
The Scripts can be called from the Share. Not local copy or local tmp directory is needed.

FFMPEG must be installed. (Version 3.2.2 recommended)

## Installation 

### Linux
The Scripts are written for bash Shell. They should run on most Linux Distributions.
You maybe need to install bash.

### OSX
A worker Script for OSX is available.
The Master Script is not tested on OSX.

### Windows

You could use cygwin.
I may will add a native windows worker batch file soon.

# Copyright
yadve is copyright 2017 by Christian Hummel.
Based on dve from https://github.com/nergdron/dve

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see the GNU licenses page.
