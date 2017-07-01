# Overview

lobvorbis-js is a JavaScript Library that encodes audio data to Ogg Vorbis on web browsers with [Browserify](http://browserify.org/).

[libogg](https://xiph.org/ogg/) and [libvorbis](https://xiph.org/vorbis/) are used for encoding engine. [Emscripten](http://emscripten.org/) is used to convert libogg/libvorbis C code into JavaScript.

this project is inspired by [OggVorbisEncoder.js](https://github.com/higuma/ogg-vorbis-encoder-js).

# Installation

```Bash
$ npm install libvorbis-js
```

# Usage

```JavaScript
var encoder = require("libvorbis-js");
```

