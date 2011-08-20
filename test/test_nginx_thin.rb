require "helper"


class TestNginxThin < MiniTest::Spec
  describe "NginxThin" do
    include Capybara::DSL

    class RackApp
      def call(env)
        [200, {'Content-Type' => 'text/plain'}, ['hello world']]
      end
    end

    def nginx_thin
      @nginx_thin ||= begin
        root = File.expand_path(File.dirname(__FILE__))
        NginxThin.new(RackApp.new, nil, root)
      end
    end

    def server_url
      nginx_thin.url
    end

    def http
      @http ||= Net::HTTP::Persistent.new
    end

    tests = lambda do
      it "will serve up a rack app" do
        begin
          nginx_thin.start
          result = http.request server_url + '/index'
          result.body.must_equal 'hello world'
        ensure
          nginx_thin.stop
        end
      end

      it "will serve up the app root" do
        begin
          nginx_thin.start
          result = http.request server_url + "/#{File.basename __FILE__}"
          result.body.must_equal File.read(__FILE__)
        ensure
          nginx_thin.stop
        end
      end

      it "supports Capybara" do
        NginxThin.capybara

        Capybara.configure { |config| config.default_driver = :selenium }
        Capybara.app = proc { |env| [200, {}, ['hello world']] }

        visit '/'

        page.text.must_equal 'hello world'
      end
    end

    describe "in forking configuration" do
      instance_eval(&tests)
    end

    describe "in threaded configuration" do
      instance_eval(&tests)
    end

    describe "supports custom nginx configs" do
      it "is pending"
    end

  end
end