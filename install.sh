#!/bin/sh

# Required Vala to C compiler, GTK3 library, WebKit2GTK(devel) and GCC (or Clang).
valac --pkg gtk+-3.0 --pkg webkit2gtk-4.0 EntryCompletion.vala Prism.vala -o /bin/prism

mkdir /usr/share/pixmaps/prism/
mkdir /usr/share/pixmaps/prism/homepage/

mkdir $HOME/.config/prism/

cp resource/*.png /usr/share/pixmaps/prism/

cp resource/homepage/* /usr/share/pixmaps/prism/homepage/

cp prism.desktop /usr/share/applications/
