module Klepto

  class Destination

    def trove
      @trove ||= Trove.new
    end

    def uids
      trove.uids
    end

    def delete(uids)
      return if uids.empty?
      trove.delete(uids)
    end

    def tootsie
      @tootsie ||= Tootsie.new
    end

    def dispatch(uid, path)
      tootsie.transcode(uid, path, :notification_url => trove.notification_url(uid))
    end
  end
end
