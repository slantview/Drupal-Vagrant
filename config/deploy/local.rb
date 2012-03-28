### This file contains stage-specific settings ###
 
# Set the deployment directory on the target hosts.
set :deploy_to, "/var/www"
 
# The hostnames to deploy to.
role :web, "localhost"
 
# Specify one of the web servers to use for database backups or updates.
# This server should also be running Drupal.
role :db, "localhost", :primary => true
 
# The username on the target system, if different from your local username
ssh_options[:user] = 'root'
ssh_options[:port] = 2222 
 
# The path to drush
set :drush, "cd #{current_path}/app ; drush "