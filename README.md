# Line-Breaker Package

[![Build Status](https://travis-ci.org/EddyLuten/line-breaker.svg?branch=master)](https://travis-ci.org/EddyLuten/line-breaker)
[![Plugin installs!](https://img.shields.io/apm/dm/line-breaker.svg?style=flat-square)](https://atom.io/packages/line-breaker)
[![Package version!](https://img.shields.io/apm/v/line-breaker.svg?style=flat-square)](https://atom.io/packages/line-breaker)
[![Dependencies!](https://img.shields.io/david/EddyLuten/line-breaker.svg?style=flat-square)](https://david-dm.org/EddyLuten/line-breaker)

An [Atom](http://atom.io/) package for breaking long lines of text at the
preferred line length boundary. Able to handle entire documents, commented code,
and indented text. See the screenshots below for some examples.

## Keybindings

* Break the selected lines or the current line and preserve indentation:
  * `alt-cmd-enter` on macOS
  * `alt-ctrl-enter` on Windows and Linux

* Break the selected lines or the current line and *ignore* indentation:
  * `alt-cmd-shift-enter` on macOS
  * `alt-ctrl-shift-enter` on Windows and Linux

## Screenshots

Breaking a long line:
![Screenshot](http://i.imgur.com/DiaHlHK.gif)

Breaking a collection of paragraphs:
![Screenshot](http://i.imgur.com/w3MqM9X.gif)

Breaking variably indented paragraphs
![Screenshot](http://i.imgur.com/dw0SlcE.gif)

Breaking long comments
![Screenshot](http://i.imgur.com/ohtLPdv.gif)

Building a paragraph from incongruous lines:
![Screenshot](http://i.imgur.com/TGr86lx.gif)

## Changelog

### 0.4.1 - Bug Fix
* Fixes a breaking bug when breaking lines (issue #5)

### 0.4.0 - Paragraph Support
* Now retains paragraphs when multiple are selected
* New binding to break and ignore the indentation level `alt-cmd-shift-enter`
* New GIFs in the README to show the various capabilities
* Support for block-style comments through Atom's updated capabilities

### 0.3.3 - Windows and Linux Compatibility
* Key mappings now compatible with Windows and Linux
* Removed Windows install-breaking text-buffer dependency
* Added `test.txt` which is shown in the animated screenshot containing an
  excerpt from The Picture of Dorian Grey

### 0.3.2 - Another Compatibility Hotfix
* Now compatible with text-buffer 9.x

### 0.3.1 - Compatibility Hotfix
* Now compatible with the newer `atom.config.get/set` methods

### 0.3.0 - Breaking comments
* Breaking comment lines properly
* Improved undo behavior

### 0.1.0 / 0.2.0 - First Release
* The whole shebang.

**TODO**
* Add unit tests
