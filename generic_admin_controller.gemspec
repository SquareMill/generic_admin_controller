# -*- encoding: utf-8 -*-
require File.expand_path('../lib/generic_admin_controller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["TODO"]
  gem.email         = ["TODO"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/SquareMill/generic_admin_controller"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "generic_admin_controller"
  gem.require_paths = ["lib"]
  gem.version       = GenericAdminController::VERSION

  gem.add_dependency "rails", ">= 4.0.0.beta1"
  gem.add_dependency "simple_form", "~> 3.0.0.beta1"
  gem.add_dependency "kaminari", "~> 0.14.1"

  # Also required, but not sure if we can make them gem dependencies:
  # bootstrap
  # jquery
end
