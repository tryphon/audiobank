module UserVoiceHelper

  def user_voice_feedback
    javascript_tag do
      code = <<-JS
        var uservoiceJsHost = ("https:" == document.location.protocol) ? "https://uservoice.com" : "http://cdn.uservoice.com";
        document.write(unescape("%3Cscript src='" + uservoiceJsHost + "/javascripts/widgets/tab.js' type='text/javascript'%3E%3C/script%3E"))
      JS
    end +
    javascript_tag do
      code = <<-JS
        UserVoice.Tab.show({ 
        key: 'audiobank',
        host: 'audiobank.uservoice.com', 
        forum: 'general', 
        alignment: 'left', /* 'left', 'right' */
        background_color:'#66af16', 
        text_color: 'white', /* 'white', 'black' */
        hover_color: '#a3de5b',
        lang: 'fr' /* 'en', 'de', 'nl', 'es', 'fr' */
        })
      JS
    end
  end

end
