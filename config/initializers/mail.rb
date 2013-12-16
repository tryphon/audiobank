# REMOVEME with mail > 2.5.4 or ruby >= 1.9 
# See #902.

require 'mail'

class Mail::SMTP
	private

	def ssl_context
		openssl_verify_mode = settings[:openssl_verify_mode]

    if openssl_verify_mode.kind_of?(String)
      openssl_verify_mode = "OpenSSL::SSL::VERIFY_#{openssl_verify_mode.upcase}".constantize
    end
      
		context = Net::SMTP.default_ssl_context
		context.verify_mode = openssl_verify_mode
		context.ca_path = settings[:ca_path] if settings[:ca_path]
		context.ca_file = settings[:ca_file] if settings[:ca_file]
		context
	end

end
