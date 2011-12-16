require 'thor'
require 'klepto'

module Klepto

  class CLI < Thor
    desc "upload", "Upload photos from the filesystem"
    method_option :archive, :type => :string, :aliases => "-a", :desc => "The archive label, e.g. 'buskerud'"
    method_option :source_path, :type => :string, :aliases => "-p", :desc => "Path to photos on the filesystem, e.g. /home/frankenstein/photos"
    method_option :trove_api_key, :type => :string, :aliases => "-k"
    method_option :trove_server, :type => :string, :aliases => "-s"
    method_option :tootsie_server, :type => :string, :aliases => "-t"
    method_option :s3_bucket, :type => :string, :aliases => "-b", :desc => "The bucket for the s3 domain"
    method_option :file, :type => :string, :aliases => "-f", :desc => "A .yml file containing config values."
    method_option :environment, :type => :string, :aliases => "-e", :desc => "The environment to use if the .yml file has multiple environment."
    method_option :confirm, :type => :boolean, :aliases => "-c", :default => false, :desc => "Show the UIDs that would change, then ask if you want to continue."
    def upload
      configure(options)
      sync = Synchronizer.new
      puts "Starting upload for '#{sync.archive}' from '#{sync.source_path}'"
      perform(sync, :confirm => options[:confirm])
    end

    desc "sync", "Sync photos from the filesystem. Deletes the diff."
    method_option :archive, :type => :string, :aliases => "-a", :desc => "The archive label, e.g. 'buskerud'"
    method_option :source_path, :type => :string, :aliases => "-p", :desc => "Path to photos on the filesystem, e.g. /home/frankenstein/photos"
    method_option :trove_api_key, :type => :string, :aliases => "-k"
    method_option :trove_server, :type => :string, :aliases => "-s"
    method_option :tootsie_server, :type => :string, :aliases => "-t"
    method_option :s3_bucket, :type => :string, :aliases => "-b", :desc => "The bucket for the s3 domain"
    method_option :file, :type => :string, :aliases => "-f", :desc => "A .yml file containing config values."
    method_option :environment, :type => :string, :aliases => "-e", :desc => "The environment to use if the .yml file has multiple environment."
    method_option :confirm, :type => :boolean, :aliases => "-c", :default => false, :desc => "Show the UIDs that would change, then ask if you want to continue."
    def sync
      configure(options)
      sync = Synchronizer.new
      sync.delete_mode!
      puts "Starting sync for '#{sync.archive}' from '#{sync.source_path}'"
      perform(sync, :confirm => options[:confirm])
    end

    private
    def configure(options)
      configuration_options = options.dup
      Klepto.configure(configuration_options)
    end

    def perform(sync, options = {})

      puts "Total #{sync.source.uids.size} images at source path."

      if sync.uids_for_upload.empty?
        puts "Nothing to upload."
      else
        puts "Will upload the following (#{sync.uids_for_upload.count}/#{sync.source.uids.count}): "
        sync.uids_for_upload.each do |uid, file|
          puts "\t#{uid}\t#{file}"
        end
      end

      if sync.delete?
        if sync.uids_for_deletion.empty?
          puts "Nothing to delete."
        else
          puts "Will delete the following (#{sync.uids_for_deletion.count}): "
          sync.uids_for_deletion.each do |uid|
            puts "\t#{uid}"
          end
        end
      end

      if sync.uids_for_deletion.empty? && sync.uids_for_upload.empty?
        exit(0)
      end

      if options[:confirm]
        print "Do you wish to continue? [Y/n] "
        confirmation = $stdin.gets.chomp

        if confirmation.downcase == "n"
          exit(0)
        end
      end

      puts "Beginning synchronization from #{sync.source_path}"
      sync.synchronize
      puts "Synchronization complete. Transcoding happens asynchronously, and may not have completed yet."

      sync.synchronize
    end
  end
end
