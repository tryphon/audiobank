function audiobank_embed(cast_id) {
  document.write('<embed src="http://www.jeroenwijering.com/embed/mediaplayer.swf" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" height="20" width="385"');
  document.write(' flashvars="file=http://audiobank.tryphon.org/casts/' + cast_id + '.mp3" />');
}
