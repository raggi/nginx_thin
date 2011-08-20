class NginxThin
  class ThinServer
    attr_reader :server

    def initialize(rack_app, socket, forking = false)
      @socket = socket
      @forking = forking
      opts = {
        :app => rack_app,
        :server => :thin,
        :Host => socket,
        :environment => 'test'
      }

      if Rack.release.to_f < 1.3
        Rack::Server.class_eval do
          def initialize(options)
            @options = options
            @app = options[:app] if options[:app]
          end
        end
      end

      @server = Rack::Server.new(opts)
      Thin::Logging.silent = true
      # Thin::Logging.trace = true
    end

    def forking?
      @forking
    end

    def start_forking
      @cpid = fork do
        trap(:INT) { EM.next_tick { EM.stop ; exit! } }
        GC.start
        ActiveRecord::Base.connection.reset! if Object.const_defined?(:ActiveRecord)
        EM.run { @server.start }
      end
    ensure
      stop if $! && @cpid
    end

    def stop_forking
      Process.kill :INT, @cpid
      Process.waitpid @cpid
    rescue Errno::ESRCH, Errno::ECHILD
      nil
    end

    def start_thread
      @thread = Thread.new { EM.run }
      @server.start
    ensure
      stop if $!
    end

    def stop_thread
      EM.next_tick { EM.stop }
      @thread.join
    end

    def start
      if forking?
        start_forking
      else
        start_thread
      end
    end

    def stop
      if forking?
        stop_forking
      else
        stop_thread
      end
    end
  end
end