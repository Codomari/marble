require "http/server"
require "uri"

module Marble::Middlewares
  class Cors
    private alias Context = ::HTTP::Server::Context

    DEFAULT_ALLOWED_HEADERS = "Accept, Authorization, Content-Type, X-Requested-With"
    DEFAULT_ALLOWED_METHODS = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
    DEFAULT_ALLOWED_ORIGINS = "*.marble.local"
    DEFAULT_MAX_AGE         = "86400"

    include HTTP::Handler

    def initialize(@allowed_origins : Array(String) = self.class.default_allowed_origins)
    end

    def call(context : Context) : Nil
      apply_headers(context)

      if context.request.method == "OPTIONS"
        context.response.status_code = 204
        context.response.content_length = 0
        return
      end

      call_next(context)
    end

    def self.default_allowed_origins : Array(String)
      (ENV["MARBLE_CORS_ALLOWED_ORIGINS"]? || DEFAULT_ALLOWED_ORIGINS)
        .split(",")
        .map(&.strip)
        .reject(&.empty?)
    end

    private def apply_headers(context : Context) : Nil
      allowed_origin = allowed_origin_for(context.request.headers["Origin"]?)
      return unless allowed_origin

      headers = context.response.headers
      headers["Access-Control-Allow-Origin"] = allowed_origin
      headers["Access-Control-Allow-Methods"] = DEFAULT_ALLOWED_METHODS
      headers["Access-Control-Allow-Headers"] = allowed_headers_for(context)
      headers["Access-Control-Max-Age"] = DEFAULT_MAX_AGE
      append_vary_origin(headers)
    end

    private def allowed_origin_for(origin : String?) : String?
      return "*" if @allowed_origins.includes?("*")
      return nil unless origin

      @allowed_origins.any? { |allowed| origin_matches?(origin, allowed) } ? origin : nil
    end

    private def origin_matches?(origin : String, allowed : String) : Bool
      return true if origin == allowed
      return wildcard_origin_matches?(origin, allowed) if allowed.starts_with?("*.")

      false
    end

    private def wildcard_origin_matches?(origin : String, allowed : String) : Bool
      host = URI.parse(origin).host.try(&.downcase)
      return false unless host

      suffix = allowed.lchop("*.").downcase
      host == suffix || host.ends_with?(".#{suffix}")
    rescue URI::Error
      false
    end

    private def allowed_headers_for(context : Context) : String
      context.request.headers["Access-Control-Request-Headers"]? || DEFAULT_ALLOWED_HEADERS
    end

    private def append_vary_origin(headers : HTTP::Headers) : Nil
      vary = headers["Vary"]?
      unless vary
        headers["Vary"] = "Origin"
        return
      end

      has_origin = vary.split(",").any? { |value| value.strip.downcase == "origin" }
      headers["Vary"] = "#{vary}, Origin" unless has_origin
    end
  end
end
