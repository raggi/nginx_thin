# = TODO
# * Document more
# * Support custom configs + urls
# * Support multiple rack apps

require 'thin'
require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'uri'

class NginxThin
  autoload :NginxServer, 'nginx_thin/nginx_server'
  autoload :ThinServer, 'nginx_thin/thin_server'

  VERSION = '1.0.0'

  attr_reader :app_root, :rack_app, :url, :nginx_server, :rack_server, :port
  attr_reader :forking

  def initialize(rack_app, port = nil, app_root = nil, forking = true)
    @rack_app = rack_app
    @app_root = app_root || Dir.pwd + '/public'
    @port     = port == 0 ? nil : port
    @uri      = nil
    @forking  = forking
  end

  def forking?
    @forking
  end

  def start
    @rack_server = ThinServer.new(rack_app, socket, forking)
    @rack_server.start

    @nginx_server = NginxServer.new(app_root, socket, port)
    @nginx_server.start

    times = 0
    until responsive?
      times += 1
      sleep 0.01
      if times > 100
        stop
        states = "thin:#{thin_responsive?} nginx:#{nginx_responsive?}"
        raise "Timed out booting NginxThin (#{states})"
      end
    end
  end

  def nginx_responsive?
    TCPSocket.open('127.0.0.1', port) { |s| s.close; true }
  rescue
    nil
  end

  def thin_responsive?
    File.exists?(socket)
  end

  def responsive?
    thin_responsive? && nginx_responsive?
  end

  def stop
    @nginx_server.stop if @nginx_server
    # TODO  improve handling if both error out
  ensure
    @rack_server.stop if @rack_server
  end

  def url
    nginx_server.url
  end

  def port
    @port || nginx_server && nginx_server.port
  end

  def socket
    @socket ||= Dir.tmpdir + "/nginx.thin.#{@rack_app.object_id}.sock"
  end

  class <<self
    attr_accessor :forking
  end
  @forking = true

  def self.capybara(root = nil)
    root ||= (Rails.root.to_s rescue Dir.pwd) + '/public'
    root = File.expand_path(root)

    Capybara.server do |app, port|
      server = new(app, port, root, forking)
      server.start
      at_exit { server.stop }
    end
  end

end