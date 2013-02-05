jQuery ->
  $('.token_input').each (index, input) ->
    url = $(input).data "url"
    populate = $(input).data "populate"
    theme = $(input).data "theme"
    
    console.log "Init tokenInput with #{url}"
    $(input).tokenInput url, prePopulate: populate, tokenValue: "name", theme: theme, preventDuplicates: true