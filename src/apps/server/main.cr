require "../../core/runner"
require "./app"

alias ServerApp = Marble::Apps::Server::App

Marble.run(ServerApp, ARGV)
