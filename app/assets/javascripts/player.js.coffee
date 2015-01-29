$ ->
  if $("a.tryphon-player").length
    Tryphon.Player.setup {
      "ignore_player_css_url": true,
      "ignore_base_player_css_url": true,
      "url_rewriter": (url, attributes) ->
        format = url.replace(/.*\.([a-z]+)$/g, "$1")
        "/documents/listen/#{attributes.id}.#{format}"
    }
    Tryphon.Player.load()
