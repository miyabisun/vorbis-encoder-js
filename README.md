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
var quality = 0; // -1 to 1
var tags = {
  TITLE: "test_ogg",
  ALBUM: "テストアルバム",
  Artist: "みやびさん",
  LOOPSTART: "10000",
  LOOPLENGTH: "30000"
};

var encoder = new Encoder(sampleRate, numberOfChannels, quality, tags);
encoder.encodeFrom(audioBuffer);
var blob = encoder.finish();
```

