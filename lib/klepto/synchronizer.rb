module Klepto

  class Synchronizer

    attr_accessor :archive, :source_path, :delete_mode
    def initialize
      ensure_configuration

      self.archive = Klepto.archive
      self.source_path = Klepto.source_path
      self.delete_mode = false
    end

    def ensure_configuration
      Klepto.configuration_options.each do |option|
        raise MissingConfigurationOption.new("Must have '#{option.inspect}'") unless Klepto.send(option)
      end
    end

    def delete_mode!
      self.delete_mode = true
    end

    def delete?
      self.delete_mode
    end

    def synchronize
      upload
      delete if delete?
    end

    def source
      @source ||= Source.new(archive, source_path)
    end

    def destination
      @destination ||= Destination.new(archive)
    end

    def upload
      uids_for_upload.each do |uid, file|
        destination.dispatch(uid, file)
      end
    end

    def delete
      destination.delete(uids_for_deletion)
    end

    def diff
      unless @uids_for_upload && @uids_for_deletion
        @uids_for_upload = source.uids.dup
        @uids_for_deletion = destination.uids.dup

        @uids_for_upload.keys.each do |uid|
          if destination.uids.include?(uid)
            @uids_for_upload.delete(uid)
            @uids_for_deletion.delete(uid)
          end
        end
      end
    end

    def uids_for_upload
      diff
      @uids_for_upload
    end

    def uids_for_deletion
      diff
      @uids_for_deletion
    end

  end
end
