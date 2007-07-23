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
require 'rdoc/usage'

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
    
$DEBUG=false
local=false

login = nil
password = nil

opts.each do |opt, arg|
  case opt
    when '--help'
      RDoc::usage
    when '--username'
      login = arg
    when '--password'
      password = arg
    when '--debug'
      $DEBUG=true
    when '--local'
      local=true
  end
end    

if login.nil?
  puts "Missing username (try --help)"
  exit 1
end

if password.nil?
  puts "Missing password (try --help)"
  exit 1
end

user_key = "#{login}/#{password}"

if ARGV.length == 0
  puts "Missing command argument (try --help)"
  exit 1
end

command = ARGV.shift

command_create=false
command_upload=false
command_confirm=false

file = nil
name = nil
document_nil = nil

case command
  when 'create'
    name = ARGV.shift
    command_create=true
  when 'upload'
    document_id = ARGV.shift.to_i
    file = ARGV.shift
    command_upload=true
  when 'confirm'
    document_id = ARGV.shift.to_i
    command_confirm=true
  when 'import'
    command_create=true
    command_upload=true
    command_confirm=true
    file = ARGV.shift
end

raise "file not found: #{file}" unless file.nil? or File.exist?(file)
      
begin
  wsdl = 'http://audiobank.tryphon.org/document/service.wsdl'
  if local then
    wsdl = 'http://localhost:3000/document/service.wsdl'
  end
  
  factory = WSDLDriverFactory.new(wsdl)
  document_service = factory.create_rpc_driver
  document_service.wiredump_dev= STDOUT if $DEBUG
  
  if command_create then
    if name.nil? and not file.nil? then
      File.basename(file) =~ /([^\.]+)\..*$/
      name = $1
    end
    
    raise "not specified name" unless name

    puts "create document : '#{name}'"
    document_id = document_service.create(user_key, name)
    puts "new document : #{document_id}"
  end
  
  if command_upload then
    raise "not document id" if document_id.nil?
    raise "not specified file" if file.nil?
    
    upload_url = document_service.url(user_key, document_id)
    puts "upload_url: #{upload_url}" if $DEBUG
    
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

  if command_confirm then
    raise "not document id" if document_id.nil?

    puts "document #{document_id}: confirm upload"
    document_service.confirm(user_key, document_id)
  end
rescue Exception
  $stderr.print "An error occured: #{$!}\n"
  raise if $DEBUG
  exit 1
end
