#!/bin/sh

# Required Vala to C compiler, GTK3 library, WebKit2GTK(devel) and GCC (or Clang).
valac --pkg gtk+-3.0 --pkg webkit2gtk-4.0 Prism.vala -o prism

./prism
