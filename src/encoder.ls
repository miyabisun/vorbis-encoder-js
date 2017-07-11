require! {
  \./libvorbis.js : {
    _encoder_init: encoder_init
    _encoder_stream_init: encoder_stream_init
    _encoder_clear: encoder_clear
    _encoder_analysis_buffer: encoder_analysis_buffer
    _encoder_process: encoder_process
    _encoder_data_len: encoder_data_len
    _encoder_transfer_data: encoder_transfer_data
    HEAPU8
    HEAPU32
    HEAPF32
  }: libvorbis
  \prelude-ls : {keys, each, map, apply, at}
}
encoder_set_tag = libvorbis.cwrap \encoder_set_tag, void, <[number string string]>
set-tags = (encoder, tags)-> tags |> keys |> each (-> [encoder, it, tags.(it).to-string!]) >> (apply encoder_set_tag)

module.exports = class Encoder
  (sample-rate, num-channels, quality, tags = {})->
    @ <<<
      num-channels: num-channels
      ogg-buffers: []
      encoder: encoder_init num-channels, sample-rate, quality
    set-tags @encoder, (tags <<< {ENCODER: \vorbis-encoder-js})
    encoder_stream_init @encoder
  encode-from: (audio-buffer)->
    [0 til @num-channels]
    |> map (-> audio-buffer.get-channel-data it)
    |> (data)~>
      buffers = []
      for i from 0 to data.0.length by 4096
        [0 til @num-channels]
        |> map (at _, data) >> (.slice i, i + 4096)
        |> buffers~push
      return buffers
    |> each @~encode
  encode: (buffers)->
    length = buffers.0.length
    analysis_buffer = encoder_analysis_buffer(@encoder, buffers.0.length) .>>. 2
    for ch from 0 til @num-channels
      HEAPF32.set buffers.(ch), HEAPU32.(analysis_buffer + ch) .>>. 2
    @process length
  finish: (mime-type)->
    @process 0
    blob = new Blob @ogg-buffers, type: (mime-type or \audio/ogg)
    @cleanup!
    return blob
  cancel: ->
    encoder_clear @encoder
    delete @encoder
    delete @ogg-buffers
  cleanup: -> @cancel!
  process: (length)->
    encoder_process @encoder, length
    len = encoder_data_len @encoder
    if len > 0
      data = encoder_transfer_data @encoder
      HEAPU8.subarray data, data + len
      |> -> new Uint8Array it
      |> @ogg-buffers~push

