load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy.rb'
 
require 'capistrano/ext/multistage'
 
namespace :deploy do
 
  # Overwritten to provide flexibility for people who aren't using Rails.
  desc "Prepares one or more servers for deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    domains.each do |domain|
      dirs += [shared_path + "/#{domain}/files"]
    end
    dirs += %w(system).map { |d| File.join(shared_path, d) }
    run "umask 02 && mkdir -p #{dirs.join(' ')}" 
  end
 
  desc "Create settings.php in shared/config" 
  task :after_setup do
    configuration = <<-EOF
<?php
$db_url = 'mysql://username:password@localhost/databasename';
$db_prefix = '';
EOF
    domains.each do |domain|
      put configuration, "#{deploy_to}/#{shared_dir}/#{domain}/settings.php"
    end
  end
 
  desc "link file dirs" 
  task :after_update_code do
    domains.each do |domain|
    # link settings file
      run "ln -nfs #{deploy_to}/#{shared_dir}/#{domain}/settings.php #{release_path}/app/sites/#{domain}/settings.php"
      # remove any link or directory that was exported from SCM, and link to remote Drupal filesystem
      run "rm -rf #{release_path}/app/sites/#{domain}/files"
      run "ln -nfs #{deploy_to}/#{shared_dir}/#{domain}/files #{release_path}/app/sites/#{domain}/files"
    end
  end
 
  # desc '[internal] Touches up the released code.'
  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{release_path}"
  end
 
  desc "Flush the Drupal cache system."
  task :cacheclear, :roles => :db, :only => { :primary => true } do
    domains.each do |domain|
      run "#{drush} --uri=#{domain} cache-clear all"
    end    
  end
 
  namespace :web do
    desc "Set Drupal maintainance mode to online."
    task :enable do
      domains.each do |domain|
        run "#{drush} --uri=#{domain} vset --always-set maintenance_mode 0"
        run "#{drush} --uri=#{domain} cache-clear all"
      end
    end
 
    desc "Set Drupal maintainance mode to off-line."
    task :disable do
      domains.each do |domain|
        run "#{drush} --uri=#{domain} vset --always-set maintenance_mode 1"
        run "#{drush} --uri=#{domain} cache-clear all"
      end
    end
  end
 
  after "deploy", "deploy:cacheclear"
  after "deploy", "deploy:cleanup"
 
 
  # Each of the following tasks are Rails specific. They're removed.
  task :migrate do
  end
 
  task :migrations do
  end
 
  task :cold do
  end
 
  task :start do
  end
 
  task :stop do
  end
 
  task :restart do
  end
 
end
 
 
desc "Download a backup of the database(s) from the given stage."
task :download_db, :roles => :db, :only => { :primary => true } do
  domains.each do |domain|
    filename = "#{domain}_#{stage}.sql"
    run "#{drush} --uri=#{domain} sql-dump --structure-tables-key=common > /tmp/#{filename}"
    download("/tmp/#{filename}", "#{filename}", :via=> :scp)
  end
end