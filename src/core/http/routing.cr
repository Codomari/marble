require "kemal"
require "../../handlers/errors/not_found"
require "../../handlers/errors/not_implemented"
require "./request_handler"

module Marble::Core::HTTP
  abstract class Routing
    def attach : Nil
      map_not_found Handlers::Errors::NotFound.new
      map_any "/", Handlers::Errors::NotImplemented.new
    end

    protected def map_not_found(handler : RequestHandler) : Nil
      error 404 do |ctx, _ex|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_any(path : String, handler : RequestHandler) : Nil
      map_get path, handler
      map_post path, handler
      map_put path, handler
      map_patch path, handler
      map_delete path, handler
      map_options path, handler
    end

    protected def map_get(path : String, handler : RequestHandler) : Nil
      get path do |ctx|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_post(path : String, handler : RequestHandler) : Nil
      post path do |ctx|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_put(path : String, handler : RequestHandler) : Nil
      put path do |ctx|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_patch(path : String, handler : RequestHandler) : Nil
      patch path do |ctx|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_delete(path : String, handler : RequestHandler) : Nil
      delete path do |ctx|
        handler.handle(ctx)
      end
      nil
    end

    protected def map_options(path : String, handler : RequestHandler) : Nil
      options path do |ctx|
        handler.handle(ctx)
      end
      nil
    end
  end
end
