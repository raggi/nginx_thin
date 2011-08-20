#!/usr/bin/env rake

require 'hoe'
Hoe.plugin :doofus, :git, :minitest, :gemspec2, :rubyforge

Hoe.spec 'nginx_thin' do
  developer 'raggi', 'raggi@rubyforge.org'
  extra_dev_deps << %w(hoe-doofus >=1.0)
  extra_dev_deps << %w(hoe-seattlerb >=1.2)
  extra_dev_deps << %w(hoe-git >=1.3)
  extra_dev_deps << %w(hoe-gemspec >=1.0.0)

  extra_deps << %w(thin)

  extra_dev_deps << %w(capybara)

  self.extra_rdoc_files = FileList["**/*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.rubyforge_name   = 'libraggi'
  self.testlib          = :minitest
end
