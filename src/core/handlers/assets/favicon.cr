require "../../http/request_handler"

module Marble::Core::Handlers::Assets
  class Favicon
    include Marble::Core::HTTP::RequestHandler

    @cached_favicon = [] of UInt8
    @content_type = "image/x-icon"

    def initialize(@favicon_path : String)
      unless File.exists?(@favicon_path)
        raise "Favicon file not found at #{@favicon_path}"
      end

      check_extension!(@favicon_path)
      cache_favicon!(@favicon_path)
      detect_content_type!(@favicon_path)
    end

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 200
      ctx.response.content_type = @content_type
      @cached_favicon
    end


    private def check_extension!(path : String)
      unless [".ico", ".png", ".jpg", ".jpeg", ".gif"].includes?(File.extname(path))
        raise "Favicon file must be .ico, .png, .jpg, .jpeg or .gif"
      end
  end

    private def cache_favicon!(path : String)
      @cached_favicon = File.read(path)
    end

    private def detect_content_type!(path : String)
      case File.extname(path)
      when ".ico"
        @content_type = "image/x-icon"
      when ".png"
        @content_type = "image/png"
      when ".jpg", ".jpeg"
        @content_type = "image/jpeg"
      when ".gif"
        @content_type = "image/gif"
      end
    end
  end
end
