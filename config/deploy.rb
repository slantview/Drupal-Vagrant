### This file contains project-specific settings ###
 
# The project name.
set :application, "dev.3saas.com"
 
# List the Drupal multi-site folders.  Use "default" if no multi-sites are installed.
set :domains, ["default"]
 
# Set the repository type and location to deploy from.
set :scm, :git
set :repository,  "git@github.com:3saas/US.com-Prototype.git"
 
# Use a remote cache to speed things up
set :deploy_via, :remote_cache
 
# Multistage support - see config/sites/[STAGE].rb for specific configs
set :default_stage, "development"
set :stages, %w(production development local)
 
# Generally don't need sudo for this deploy setup
set :use_sudo, false