# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nginx_thin}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{raggi}]
  s.date = %q{2011-08-19}
  s.description = %q{A wrapper around Thin and Nginx to support easily booting them together. This
is most useful for integration test suites when you want to test through your
nginx configuration. In some cases it may also provide a performance boost for
such integration tests.}
  s.email = [%q{raggi@rubyforge.org}]
  s.executables = [%q{nginx_thin}]
  s.extra_rdoc_files = [%q{Manifest.txt}, %q{CHANGELOG.rdoc}, %q{README.rdoc}]
  s.files = [%q{.autotest}, %q{.gemtest}, %q{CHANGELOG.rdoc}, %q{Manifest.txt}, %q{README.rdoc}, %q{Rakefile}, %q{bin/nginx_thin}, %q{config.ru}, %q{lib/nginx_thin.rb}, %q{lib/nginx_thin/nginx_server.rb}, %q{lib/nginx_thin/thin_server.rb}, %q{test/gemloader.rb}, %q{test/helper.rb}, %q{test/test_nginx_thin.rb}]
  s.homepage = %q{http://rubygems.org/gems/nginx_thin}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{libraggi}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A wrapper around Thin and Nginx to support easily booting them together}
  s.test_files = [%q{test/test_nginx_thin.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 2.3.1"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe-doofus>, [">= 1.0"])
      s.add_development_dependency(%q<hoe-seattlerb>, [">= 1.2"])
      s.add_development_dependency(%q<hoe-git>, [">= 1.3"])
      s.add_development_dependency(%q<hoe-gemspec>, [">= 1.0.0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<hoe>, ["~> 2.10"])
    else
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 2.3.1"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe-doofus>, [">= 1.0"])
      s.add_dependency(%q<hoe-seattlerb>, [">= 1.2"])
      s.add_dependency(%q<hoe-git>, [">= 1.3"])
      s.add_dependency(%q<hoe-gemspec>, [">= 1.0.0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<hoe>, ["~> 2.10"])
    end
  else
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 2.3.1"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe-doofus>, [">= 1.0"])
    s.add_dependency(%q<hoe-seattlerb>, [">= 1.2"])
    s.add_dependency(%q<hoe-git>, [">= 1.3"])
    s.add_dependency(%q<hoe-gemspec>, [">= 1.0.0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<hoe>, ["~> 2.10"])
  end
end
