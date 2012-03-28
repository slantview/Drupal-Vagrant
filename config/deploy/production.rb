### This file contains stage-specific settings ###
 
# Set the deployment directory on the target hosts.
set :deploy_to, "/var/www/#{application}"
 
# The hostnames to deploy to.
role :web, "dev.3saas.com"
 
# Specify one of the web servers to use for database backups or updates.
# This server should also be running Drupal.
role :db, "dev.3saas.com", :primary => true
 
# The username on the target system, if different from your local username
# ssh_options[:user] = 'alice'
 
# The path to drush
set :drush, "cd #{current_path}/app ; drush"