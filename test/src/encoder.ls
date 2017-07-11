require! {
  chai: {expect}
  \prelude-ls : {each, find, at, flip, keys, map, sum, apply}
  lodash: {chunk}
  proxyquire, fs, mkdirp
  \../../dist/libvorbis.js
  \audio-decode
  \audio-lena/mp3 : buffer
  \audio-buffer : AudioBuffer
}
Encoder = proxyquire.no-call-thru!.load \../../src/encoder.ls,
  \./libvorbis.js : libvorbis
global <<< Blob: class Blob
  (ogg-buffers)->
    @ogg-buffers = ogg-buffers
  buffer:~ ->
    @ogg-buffers
    |> map (.buffer) >> (-> new Buffer it)
    |> Buffer.concat

filename = __filename.replace(/^.*(test)/, \test)
describe filename, ->
  describe \encoder_class ->
    specify \encoder_is_fanction ->
      Encoder |> expect >> (.to.be.a \function)
  describe \encoder_instance ->
    params = {}
    before (done)!->
      @timeout 30_000ms
      err, audio-buffer <- audio-decode buffer
      {sample-rate, number-of-channels} = audio-buffer
      encoder = new Encoder sample-rate, number-of-channels, 0,
        TITLE: \test_ogg
        ALBUM: \テストアルバム
        Artist: \みやびさん
        LOOPSTART: 10000
        LOOPLENGTH: 30000
      encoder.encode-from audio-buffer
      blob = encoder.finish!
      params <<< {err, audio-buffer, blob}
      done!
    specify \is_audio-buffer ->
      params.audio-buffer |> expect >> (.to.be.an.instanceof AudioBuffer)
    specify \create-ogg (done)->
      <- mkdirp "#__dirname/../../tmp"
      fs.write-file-sync "#__dirname/../../tmp/test.ogg", params.blob.buffer
      done!

