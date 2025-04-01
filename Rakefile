require 'jekyll'
require_relative '_lib/asset_check'
require_relative '_lib/ai_control'
require_relative '_lib/db_control'
require_relative '_lib/file_control'

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

desc 'Add all users to database'
task :db_add_all_users do
  DbControl.add_users
end

desc 'Update pictures from latest year'
task :db_update do
  DbControl.update
end

# File management tasks
desc 'Copy pictures'
task :copy_pictures do
  FileControl.copy_pictures
end

desc 'Download all picture data files'
task :pics_yaml_download_all do
  FileControl.download_all_pictures_data
end

desc 'Download latest picture data file'
task :pics_yaml_update do
  FileControl.download_latest_pictures_data
end

desc 'Download latest photographer data file'
task :users_yaml_download do
  FileControl.download_user_data
end

# Site integrity checks
desc 'Check all assets ready for build'
task :check_ready do
  AssetCheck.do_checks
end

# Monthly tasks
desc 'Monthly data update task'
task :month_update do
  Rake::Task['pics_yaml_update'].invoke
  Rake::Task['copy_pictures'].invoke
  Rake::Task['db_update'].invoke
  Rake::Task['check_ready'].invoke
end

# Image analysis tasks
desc 'Analyse missing images for year'
task :analyse_missing_images, [:year] do |_t, args|
  args.with_defaults(year: Date.today.year)
  AiControl.analyse_missing_images_for(args.year)
end

desc 'Analyse new images'
task :analyse_new_images do
  AiControl.analyse_missing_images_current_year
end
