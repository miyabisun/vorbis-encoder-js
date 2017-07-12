# Overview

vorbis-encoder-js is a JavaScript Library that encodes audio data to Ogg Vorbis on web browsers with [Browserify](http://browserify.org/).

[libogg](https://xiph.org/ogg/) and [libvorbis](https://xiph.org/vorbis/) are used for encoding engine. [Emscripten](http://emscripten.org/) is used to convert libogg/libvorbis C code into JavaScript.

this project is inspired by [OggVorbisEncoder.js](https://github.com/higuma/ogg-vorbis-encoder-js).

# Installation

```Bash
$ npm install vorbis-encoder-js
```

# Usage

```JavaScript
var Encoder = require("vorbis-encoder-js").encoder;

var sampleRate = audioBuffer.sampleRate;
var numberOfChannels = audioBuffer.numberOfChannels;
var quality = 0; // -0.1 to 1 (Vorbis quality)
var tags = {
  TITLE: "test_ogg",
  ALBUM: "テストアルバム", // UTF-8 is usable
  ARTIST: "miyabisun",
  LOOPSTART: "10000",
  LOOPLENGTH: "30000"
};

var encoder = new Encoder(sampleRate, numberOfChannels, quality, tags);
encoder.encodeFrom(audioBuffer);
var blob = encoder.finish();
```

# Build

Docker and Node.js are required to build the library.

```Bash
$ npm run build
```

Download and extract libogg + libvorbis, build library files (see [package.json](https://github.com/miyabisun/vorbis-encoder-js/blob/master/package.json) and [Makefile](https://github.com/miyabisun/vorbis-encoder-js/blob/master/Makefile) for more details).

# License

libogg and libvorbis are released under Xiph's BSD-like license below. JavaScript-converted part of this library follows the same license.

[http://www.xiph.org/licenses/bsd/](http://www.xiph.org/licenses/bsd/)

This library is released under MIT licence, see [LICENSE.txt](https://github.com/miyabisun/vorbis-encoder-js/blob/master/LICENSE.txt).

