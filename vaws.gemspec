lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vaws/version"

Gem::Specification.new do |spec|
  spec.name    = "vaws"
  spec.version = Vaws::VERSION
  spec.authors = ["Shota Ito"]
  spec.email   = ["shota.ito.jp@gmail.com"]

  spec.summary     = %q{The vaws command simplifies the display of AWS resources.}
  spec.description = %q{The vaws command simplifies the display of AWS resources.}
  spec.homepage    = "https://github.com/st1t/vaws"
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.files += Dir.glob("bin/**/*")
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("spec/**/*")
  spec.files += Dir.glob("exe/**")

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "thor", ">= 0.20.3", "< 1.1.0"
  spec.add_runtime_dependency "aws-sdk-ec2"
  spec.add_runtime_dependency "aws-sdk-elasticloadbalancingv2"
  spec.add_runtime_dependency "aws-sdk-ecs"
  spec.add_runtime_dependency "aws-sdk-route53"
  spec.add_runtime_dependency "aws-sdk-acm"
  spec.add_runtime_dependency "aws-sdk-ssm"
  spec.add_runtime_dependency "terminal-table", "~> 1.8.0"
end
