personal portage overlay

# usage
if you haven't already, install and configure [layman](https://wiki.gentoo.org/wiki/Layman)

```bash
sudo layman -o https://raw.githubusercontent.com/\
Francesco149/loli-overlay/master/overlay.xml \
-f -a loli-overlay

sudo layman -S
```

# sharenix
my sharex clone. comes pre-configured to upload images to imgur.
copy /etc/sharenix.json to ~/.sharenix.json and customize as needed.

run ```sharenix``` for help.

bind ```sharenix-window``` to a hotkey to screenshot and upload
the currently focused window.

bind ```sharenix-section``` to a hotkey to screenshot and upload a region.

see [sharenix's project page](https://github.com/Francesco149/sharenix) for
more info.

# shmupmametgm
mame optimized for Tetris The Grandmaster 2 Plus, see the
[project page](https://github.com/MaryHal/shmupmametgm)

for TGM1, see xmame in the [mv overlay](https://github.com/vaeth/mv-overlay)

by default it tries to get roms and other stuff from the PWD, you most likely
want to create a mame.ini:

```
mkdir ~/.mame
mametgm64 -showconfig > ~/.mame/mame.ini
```

and edit the various directories:

```
#
# CORE SEARCH PATH OPTIONS
#
rompath                   $HOME/.mame/roms
samplepath                $HOME/.mame/samples
artpath                   $HOME/.mame/artwork
ctrlrpath                 $HOME/.mame/ctrlr
inipath                   $HOME/.mame;.;ini
fontpath                  .
cheatpath                 $HOME/.mame/cheat
crosshairpath             $HOME/.mame/crosshair

#
# CORE OUTPUT DIRECTORY OPTIONS
#
cfg_directory             $HOME/.mame/cfg
nvram_directory           $HOME/.mame/nvram
memcard_directory         $HOME/.mame/memcard
input_directory           $HOME/.mame/inp
state_directory           $HOME/.mame/sta
snapshot_directory        $HOME/.mame/snap
diff_directory            $HOME/.mame/diff
comment_directory         $HOME/.mame/comments
```


# telegram-desktop
[official telegram client](https://github.com/telegramdesktop/tdesktop)
with a bunch of patches mostly forked from [reagentoo](
https://data.gpo.zugaina.org/reagentoo/net-im/telegram-desktop/)
with slight modifications.

install:

```bash
sudo euse --enable savedconfig
sudo emerge -a telegram-desktop
```

customize config file and recompile:
```bash
sudo nano /etc/portage/savedconfig/net-im/telegram-desktop-*
sudo emerge telegram-desktop
```

what the patches do:
* override fonts and api key through the savedconfig USE-flag and a
  config file
* respect system-wide {C,CXX,LD}FLAGS (built successfully with -O3, lto and graphite)
* bypass gyp and builds everything with CMake
* use system qt instead of building telegram's custom qt

example ```/etc/portage/savedconfig/net-im/telegram-desktop-*```
with custom fonts

```cpp
#pragma once

/* the default values for these are my own app id.
 * if you edit this, you should get your own at
 * https://core.telegram.org/api/obtaining_api_id */
#define TELEGRAM_API_ID   33266
#define TELEGRAM_API_HASH "8b40dc9cf6427eb16c493e78ac4630ac"

/* original telegram desktop key */
/* #define TELEGRAM_API_ID   17349 */
/* #define TELEGRAM_API_HASH "344583e45741c457fe1862106095a5eb" */

/* change these to any font name to override the defaults.
   example: qsl("Arial") */
#define TELEGRAM_FT_OVERRIDE           qsl("Arial")
#define TELEGRAM_FT_SEMIBOLD_OVERRIDE  qsl("Arial")
#define TELEGRAM_FT_MONOSPACE_OVERRIDE qsl("Andale Mono")
```

result:
![](http://hnng.moe/f/RwZ)

# sys-config/loli
my personal gentoo config and misc utils

NOTE: don't actually install this from my overlay, fork it and edit it with your
own hardware config. it will almost surely break your system unless you have
my exact same machine

```
su -
emerge -a app-portage/layman
layman -a lto-overlay
layman -a mv
emerge -a sys-config/loli
binutils-config --linker ld.gold
emerge gcc
emerge -e @world
```
