# coding: utf-8
require File.expand_path('../lib/generic_admin_controller/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "generic_admin_controller"
  gem.version       = GenericAdminController::VERSION
  gem.authors       = ["Conor Hunt", "Esteban Pastorino", "Peter Jaros"]
  gem.email         = [""]
  gem.description   = %q{Rails gem for creating customizable CMS's}
  gem.summary       = %q{Rails gem for creating customizable CMS's}
  gem.homepage      = "https://github.com/SquareMill/generic_admin_controller"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency "rails", "~> 4.0"
  gem.add_dependency "simple_form", "~> 3.0.0.rc"
  gem.add_dependency "kaminari", "~> 0.14.1"

  # Also required, but better not to make them gem dependencies
  gem.requirements << 'Twitter Bootstrap 2'
  gem.requirements << 'jQuery 1.7+'

end
