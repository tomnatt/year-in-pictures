require 'jekyll'
require_relative '_lib/db_control'

task :default do
  Rake::Task['build'].invoke
end

desc 'Build site after deleting cache'
task build: [:clean] do
  Jekyll::Commands::Build.process({ config: '_config/jekyll_config.yml' })
end

desc 'Build and serve'
task :serve do
  # Jekyll::Commands::Serve.process({ config: '_config/jekyll_config.yml' })
  system 'bundle exec jekyll serve --config _config/jekyll_config.yml --incremental'
end

desc 'Delete cache'
task :clean do
  Jekyll::Commands::Clean.process({ config: '_config/jekyll_config.yml' })
end

desc 'Run with profiler'
task profile: [:clean] do
  Jekyll::Commands::Build.process({ config: '_config/jekyll_config.yml', profile: true })
end

# Database tasks

desc 'Create database'
task :db_create do
  DbControl.create
end

desc 'Delete database'
task :db_delete do
  DbControl.delete
end

desc 'Add all pictures to database'
task :db_add_all_pictures do
  DbControl.add_all_pictures
end

desc 'Update pictures from latest year'
task :db_update do
  DbControl.update
end
