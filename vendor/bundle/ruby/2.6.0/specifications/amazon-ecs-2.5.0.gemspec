# -*- encoding: utf-8 -*-
# stub: amazon-ecs 2.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "amazon-ecs".freeze
  s.version = "2.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Herryanto Siatono".freeze]
  s.date = "2016-07-09"
  s.description = "Generic Amazon Product Advertising Ruby API.".freeze
  s.email = "herryanto@gmail.com".freeze
  s.homepage = "https://github.com/jugend/amazon-ecs".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Generic Amazon Product Advertising Ruby API.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
      s.add_runtime_dependency(%q<ruby-hmac>.freeze, ["~> 0.3"])
    else
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
      s.add_dependency(%q<ruby-hmac>.freeze, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
    s.add_dependency(%q<ruby-hmac>.freeze, ["~> 0.3"])
  end
end
