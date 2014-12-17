class Dropbox < ActiveRecord::Base

  attr_accessible :login, :password
  belongs_to :user

  validates_presence_of :login, :password, :directory

  def self.for_file(file)
    file = Pathname.new(file).absolute_path_from!(root)

    file.ascend do |path|
      next if path == file

      if not root.include?(file) or root == file
        return nil
      end

      if dropbox = where(directory: path.to_s).first
        return dropbox
      end
    end

    nil
  end

  def import(file)
    Import.new(user, file).import
  end

  def set_defaults
    self.login ||= user.username if user
    self.directory ||= login

    if directory
      self.directory = Pathname.new(directory).absolute_path_from!(root).to_s
    end

    self.password ||= SecureRandom.hex
  end
  before_validation :set_defaults

  def create_directory
    FileUtils.mkdir_p directory
    File.chmod 02775, directory.to_s
  end
  before_validation :create_directory, on: :create

  def destroy_directory
    FileUtils.rmdir directory
  end
  after_destroy :destroy_directory

  class Import

    attr_accessor :user, :file

    def initialize(user, file)
      @user, @file = user, file
    end

    def default_title
      basename.gsub(/[\W_][\W_]*/, " ").gsub(/^#{document_id}/, "").strip.capitalize
    end

    def default_description
      "Uploaded at #{Time.now}"
    end

    def basename
      @basename ||= File.basename(file, File.extname(file))
    end

    def document_id
      if basename =~ /^([0-9]+)[\W_]/
        $1.to_i
      end
    end

    def document
      @document ||=
        if document_id and document = user.documents.where(id: document_id).first
          document
        else
          user.documents.create! title: default_title, description: default_description
        end
    end

    def import
      if document.upload_file(File.new(file)) and document.save
        FileUtils.rm file
      end
    end

  end

  @@root = Rails.root + "tmp/dropboxes"
  cattr_accessor :root

  def self.root=(root)
    @@root = Pathname.new root
  end

  def self.listen
    FileUtils.mkdir_p root unless File.exists?(root)

    processing_files = []

    inotify = INotify::Notifier.new
    inotify.watch(root.to_s, :recursive, :close_write) do |event|
      Rails.logger.debug "Inotify event: #{event.inspect}"

      filename = event.absolute_name

      # File can be removed between event and now
      # Ignore file under processing, import creates inotify events
      if File.exists?(filename) and not processing_files.include? filename
        processing_files.unshift filename
        begin
          relative_filename = Pathname.new(filename).relative_path_from(root)

          if dropbox = Dropbox.for_file(filename)
            if dropbox.import(filename)
              Rails.logger.info "Dropbox file #{filename} imported"
            else
              Rails.logger.error "Dropbox file #{filename} can't be imported"
            end
          else
            Rails.logger.info "No dropbox found for file #{filename}"
          end
        rescue Exception => e
          Rails.logger.error "Dropbox event process failed for file #{filename}: #{e} #{e.backtrace}"
        ensure
          processing_files.delete filename
        end
      end
    end
    inotify.run
  end

end
