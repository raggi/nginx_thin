class NginxThin
  class NginxServer
    attr_reader :config_file, :port, :app_root, :socket

    def initialize(app_root, socket, port = nil)
      @app_root, @socket, @port = app_root, socket, port
      @tmpdir = Dir.tmpdir + "/nginx_thin.#{$$}"
      @config_file = @tmpdir + "/nginx_thin.#{$$}.conf"
      @port ||= TCPServer.open(0) { |s| break s.addr[1] }
      mkdirs
    end

    def mkdirs
      FileUtils.mkdir_p @tmpdir + '/var/run'
      FileUtils.mkdir_p @tmpdir + '/var/log'
    end

    def start
      write_config
      test_config
      system "#{nginx} 2>/dev/null"
    ensure
      stop if $!
    end

    def stop
      system "#{nginx} -s quit 2>/dev/null"
    ensure
      FileUtils.rm_rf @tmpdir if File.exists?(@tmpdir)
    end

    def test_config
      out = `#{nginx} -t 2>&1`
      unless $?.success?
        system "open #{@config_file}"
        $stderr.puts out
        $stderr.puts File.read(@config_file)
        raise "Nginx config failed"
      end
    end

    def nginx
      "nginx -c #{@config_file} -p #{@tmpdir}"
    end

    def pidfile
      "#{@tmpdir}/nginx_thin.#{$$}.pid"
    end

    def write_config
      open(@config_file, 'w+') do |file|
        file.write <<-CONFIG
        worker_processes 1;
        daemon on;
        pid #{pidfile};
        error_log "#{@tmpdir}/error.log";

        events { worker_connections 1024; }

        http {
          error_log "#{@tmpdir}/error.log";
          access_log off;

          sendfile on;
          keepalive_timeout 0;
          keepalive_requests 0;

          upstream "nginx_thin#{$$}" {
            server "unix:#{socket}";
          }
          include "#{mimes_file}";

          server {

            listen localhost:#{port};

            # TODO: ssl sockets and how to identify url, etc
            # listen localhost:\#{ssl_port} ssl;

            server_name localhost 127.0.0.1;

            root "#{app_root}";

            location = ^/(?:robots\.txt|favicon\.ico)$ {
              expires 1d;
              try_files $uri =204;
            }

            location ~* \.(?:css|csv|f4v|gif|html|htm|ico|jpe?g|js|pdf|png|swf|txt|xml|zip|htc)$ {
              if ( $args ~ ^[0-9]+$ ) {
                expires max;
                add_header Cache-Control public;
              }
              try_files $uri @app =404;
            }

            location / {
              try_files $uri @app;
            }

            proxy_set_header  Referer           $http_referer;
            proxy_set_header  X-Real-IP         $remote_addr;
            proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header  X-Forwarded-Proto $http_x_forwarded_proto;
            proxy_set_header  Host              $http_host;
            proxy_redirect    off;

            location @app { proxy_pass http://nginx_thin#{$$}; }
          }
        }
        CONFIG
      end
    end

    def mimes_file
      opts = `nginx -V 2>&1`.grep(/configure/).first.split(' --')
      opts = Hash[opts.map! { |o| o.split('=') }]
      File.dirname(opts['conf-path']) + '/mime.types'
    end

    def url
      URI("http://localhost:#{port}")
    end
  end
end