require_relative 'lib/evntaly/version'

Gem::Specification.new do |spec|
  spec.name          = "evntaly"
  spec.version       = Evntaly::VERSION
  spec.authors       = ["Sayed Alesawy"]

  spec.summary       = "Evntaly official library for your ruby projects"
  spec.homepage      = "https://github.com/Evntaly/evntaly-ruby"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]

  # Add dependencies here
  spec.add_runtime_dependency "net-http", "~> 0.1.0"
  spec.add_runtime_dependency "json", "~> 2.5"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency 'byebug'

  # post-install message
  spec.post_install_message = "Thank you for using the Evntaly SDK. For more details, visit https://evntaly.com"
end
