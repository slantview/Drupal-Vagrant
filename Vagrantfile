# To Run:
#  $ export ORGNAME=slantview
#  $ export VAGRANT_BOX=centos6-64
#  $ export VAGRANT_SHARE=~/Documents/workspace
#  $ export OPSCODE_USER=slantview
#  $ vagrant up
#
 
user = ENV['OPSCODE_USER'] || ENV['USER']
base_box = ENV['VAGRANT_BOX'] || 'lucid32'
share =  ENV['VAGRANT_SHARE'] || "."
oc_org_name = ENV['OPSCODE_ORGNAME'] || ENV['ORGNAME'] 
cwd = File.dirname(__FILE__)


Vagrant::Config.run do |config|
  config.vm.box = base_box

  config.vm.host_name = "local.deployr.com"
  
  # Set up some ports to open up
  config.vm.forward_port 80, 8080
  config.vm.forward_port 443, 8443
  config.vm.forward_port 3306, 3306
  
  # Configure a share folder
  config.vm.share_folder "v-data", "/data", "#{share}"
  config.vm.share_folder "v-www", "/var/www/releases/_default_", "#{cwd}/../app"

  config.vm.provision :chef_client do |chef|

    # Set up some organization specific values based on environment variable above.
    chef.chef_server_url = "http://package.workhabit.com:4000"
    chef.validation_key_path = "#{cwd}/certificates/validation.pem"
    chef.validation_client_name = "chef-validator"
 
    # Change the node/client name for the Chef Server
    chef.node_name = "#{user}-#{base_box}-vagrant"
 
    # Put the client.rb in /etc/chef so chef-client can be run w/o specifying
    chef.provisioning_path = "/etc/chef"
 
    # logging
    chef.log_level = :info

    # Set to chef environment
    chef.environment = "ubuntu"

    # Add role "development" for dev servers.
    chef.add_role("development")

    # Merge our json settings.
    chef.json.merge!({
      :drupal => {
        :dir => "/var/www",
        :db => {
          :database => "drupal"
        }
      },
      :varnish => {
        :listen_address => "",
        :listen_port => "80"
      }
    })

  end
end
