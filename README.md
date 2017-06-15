Personal portage overlay that I use for tweaks.

# Adding the overlay
Install and configure [layman](https://wiki.gentoo.org/wiki/Layman)
if you don't have it already.

```bash
sudo layman -o https://raw.githubusercontent.com/\
Francesco149/loli-overlay/master/overlay.xml \
-f -a loli-overlay

sudo layman -S
```

Now you are ready to install any package in this overlay.

# telegram-desktop
This is the [official telegram client](
https://github.com/telegramdesktop/tdesktop) with a bunch of
patches mostly forked from [reagentoo](
https://data.gpo.zugaina.org/reagentoo/net-im/telegram-desktop/)
with slight modifications.

Install:

```bash
sudo euse --enable savedconfig
sudo emerge -a telegram-desktop
```

Customize config file and recompile:
```bash
sudo nano /etc/portage/savedconfig/net-im/telegram-desktop-*
sudo emerge telegram-desktop
```

What the patches do:
* Override fonts and API Key through the savedconfig USE-flag and a
  config file. Who thought hardcoding the app to a single font and
  being so adamant about it was a good idea?
* Allow the thing to even compile, because the build system is so
  horrible it doesn't work out of the box - some CMake files even
  ignore CXX flags and complain they want c++14.
* Bypass gyp and builds everything with CMake.

Example ```/etc/portage/savedconfig/net-im/telegram-desktop-*```
that overrides the fonts with pixel-perfect ones that work well
with no anti-aliasing (note that you need to have the fonts
installed in your system and they won't be bundled with the app):

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
