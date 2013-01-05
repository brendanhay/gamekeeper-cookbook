module GameKeeper
  class Settings

    attr_reader :version, :checksum, :user, :uri

    def initialize(version, checksum, user, uri)
      @version, @checksum, @user, @uri = version, checksum, user, uri
    end

    def home
      "/opt/gamekeeper-#{version}"
    end

    def bin
      "gamekeeper"
    end

    def path
      "#{home}/#{bin}"
    end

    def tar
      "/var/tmp/#{bin}-#{version}.tar.gz"
    end

    def source
      "http://artifacts.int.s-cloud.net/#{bin}-#{version}.tar.gz"
    end

    def installed?
      File.exists?(path)
    end

  end
end
