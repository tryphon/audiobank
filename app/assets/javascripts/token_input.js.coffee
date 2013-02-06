jQuery ->
  $('.token_input').each (index, input) ->
    url = $(input).data "url"
    populate = $(input).data "populate"
    theme = $(input).data "theme"

    value = $(input).data "value"
    value ?= "id"

    property_to_search = $(input).data "property-to-search"
    property_to_search ?= "name"
    
    console.log "Init tokenInput with #{url}"
    $(input).tokenInput url, prePopulate: populate, tokenValue: value, theme: theme, preventDuplicates: true, propertyToSearch: property_to_search
