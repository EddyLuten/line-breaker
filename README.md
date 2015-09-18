# Line-Breaker Package

[![Build Status](https://travis-ci.org/EddyLuten/line-breaker.svg?branch=master)](https://travis-ci.org/EddyLuten/line-breaker)
[![Plugin installs!](https://img.shields.io/apm/dm/line-breaker.svg?style=flat-square)](https://atom.io/packages/line-breaker)
[![Package version!](https://img.shields.io/apm/v/line-breaker.svg?style=flat-square)](https://atom.io/packages/line-breaker)
[![Dependencies!](https://img.shields.io/david/EddyLuten/line-breaker.svg?style=flat-square)](https://david-dm.org/EddyLuten/line-breaker)

An [Atom](http://atom.io/) package that breaks long lines of text.

Keybindings:
* `alt-cmd-enter` breaks the selected lines or the current line.

Breaks long lines on the preferred line length boundaries while keeping the indentation
of the first line in place.

![Screenshot](https://raw.githubusercontent.com/EddyLuten/line-breaker/master/screenshot.gif)

Works well with contiguous selections of text or long single lines of text and with Atom-supported comments:

![Screenshot](https://raw.githubusercontent.com/EddyLuten/line-breaker/master/comments.gif)

**TODO**
* Add unit tests
* Support block comments, once Atom does as well.
