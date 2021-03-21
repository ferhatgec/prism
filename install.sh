#!/bin/sh


mkdir $HOME/.config/prism/

# Required Vala to C compiler, GTK3 library, WebKit2GTK(devel) and GCC (or Clang).
sudo valac --pkg gtk+-3.0 --pkg webkit2gtk-4.0 src/Definitions.vala src/Log.vala src/FileOperations.vala src/EntryCompletion.vala src/Prism.vala -o /bin/prism

sudo mkdir /usr/share/pixmaps/prism/
sudo mkdir /usr/share/pixmaps/prism/homepage/

sudo cp resource/*.png /usr/share/pixmaps/prism/

sudo cp resource/homepage/* /usr/share/pixmaps/prism/homepage/

sudo cp prism.desktop /usr/share/applications/