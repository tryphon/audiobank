#!/usr/bin/ruby

# == Synopsis
#
# audiobank-client: command line for audiobank
#
# == Usage
#
# audiobank-client --username username --password password [OPTION] ... create TITLE
#
# audiobank-client --username username --password password [OPTION] ... upload ID FILE
#
# audiobank-client --username username --password password [OPTION] ... confirm ID
#
# audiobank-client --username username --password password [OPTION] ... import FILE
#
# -h, --help:
#    show help
#
# --username username:
#    audiobank username
#
# --password password:
#    audiobank password
#
# --debug:
#    disable debug messages
#
# --local:
#    use a local audiobank server (developper only)
#
# ID: The audiobank document identifier
#
# TITLE: The audiobank document title 
#
# FILE: A local sound file

require 'fileutils'
require 'soap/wsdlDriver'

require 'getoptlong'

require 'net/ftp'

include SOAP

module HTTP
  class << self
    def keep_alive_enabled?(version)
      false
    end  
  end
end

opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--username', '-u', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--password', '-p', GetoptLong::REQUIRED_ARGUMENT ],
      [ '--debug', '-d', GetoptLong::NO_ARGUMENT ],
      [ '--local', '-l', GetoptLong::NO_ARGUMENT ]
    )

class AudioBankClient

  attr_accessor :local, :debug, :login, :password

  def initialize(options = {})
    options.each { |k, v| send "#{k}=", v }
  end

  def user_key
    "#{login}/#{password}"
  end

  def wsdl
    if local 
      'http://audiobank.local/document/service.wsdl'
    else
      'http://audiobank.tryphon.org/document/service.wsdl'
    end
  end

  def factory
    factory = WSDLDriverFactory.new(wsdl)
  end

  def document_service
    @document_service ||= factory.create_rpc_driver.tap do |service|
      service.wiredump_dev = STDOUT if debug
    end
  end

  def create(name)
    raise "not specified name" unless name

    puts "create document : '#{name}'"
    document_id = document_service.create(user_key, name)
    puts "new document : #{document_id}"
    document_id
  end
    
  def upload(document_id, file)
    raise "not document id" if document_id.nil?
    check_file file

    upload_url = document_service.url(user_key, document_id)
    puts "upload_url: #{upload_url}" if debug
    
    puts "document #{document_id}: uploading ..."
    if local then
      upload_url =~ /.*\/([a-z0-9]+)\/$/
      upload_url = "#{FileUtils.pwd}/media/upload/#{$1}"
      puts "document #{document_id}: local upload_url: #{upload_url}" if $DEBUG
      FileUtils.cp([ file ], upload_url)
    else
      upload_url =~ /ftp:\/\/([a-z0-9\.]+)\/(.*)$/
      ftp_host = $1
      ftp_directory = $2

      puts "document #{document_id}: starting ftp upload"
      
      ftp = Net::FTP.open(ftp_host) do |ftp|
        ftp.login
        ftp.chdir(ftp_directory)
        ftp.putbinaryfile(file)
      end
    end
    puts "document #{document_id}: uploaded"
  end

  def confirm(document_id)
    raise "not document id" if document_id.nil?

    puts "document #{document_id}: confirm upload"
    document_service.confirm(user_key, document_id)
  end

  def check_file(file)
    raise "not specified file" if file.nil?
    raise "file not found: #{file}" unless file.nil? or File.exist?(file)
  end

  def import(files)
    Array(files).each do |file|
      check_file file
      
      name = File.basename(file, File.extname(file))
      
      document_id = create(name)
      upload document_id, file
      confirm document_id
    end
  end

end

client = AudioBankClient.new

opts.each do |opt, arg|
  case opt
  when '--username'
    client.login = arg
  when '--password'
    client.password = arg
  when '--debug'
    client.debug = true
  when '--local'
    client.local = true
  end
end    

if client.login.nil?
  puts "Missing username (try --help)"
  exit 1
end

if client.password.nil?
  puts "Missing password (try --help)"
  exit 1
end

command = ARGV.shift
unless command
  puts "Missing command argument (try --help)"
  exit 1
end

begin
  case command
  when 'create'
    client.create ARGV.shift
  when 'upload'
    client.upload ARGV.shift.to_i, ARGV.shift
  when 'confirm'
    client.confirm ARGV.shift.to_i
  when 'import'
    client.import ARGV
  end
rescue Exception
  $stderr.print "An error occured: #{$!}\n"
  raise if client.debug
  exit 1
end
