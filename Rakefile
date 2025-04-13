require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

module Tools
  class Releaser < Bundler::GemHelper
    def release(remote='origin')
      tag_version do
        git_push(remote)
      end unless already_tagged?
    end
  end
end

desc 'Creates a tag using version.rb and pushes it to GitHub'
task 'gh-release', [:remote] do
  Tools::Releaser.new.release
end
