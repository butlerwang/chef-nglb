###############################

# File Name : nglb.rb

# Purpose :

# Creation Date : 09-06-2016

# Last Modified : Tue Jun 20 11:17:04 2017

# Created By : Kiyor

###############################

package "go-daemon" do
  action :install
end

template "/etc/init.d/nglb" do
  source "init_go-daemon.erb"
  mode "0755"
  variables(
    :name => "nglb"
  )
  notifies :restart, "service[nglb]", :delayed
end

link "/usr/local/bin/nglb-god" do
  to "/usr/local/bin/go-daemon"
  only_if { File.exist?("/usr/local/bin/go-daemon") }
end

cookbook_file "/usr/local/bin/nglb" do
  source "nglb"
  owner "root"
  group "root"
  mode "0755"
  action :create
  notifies :restart, "service[nglb]", :delayed
end

cookbook_file "/usr/local/nginx/conf/nglb.json" do
  source "nglb_" + node["ccna"]["server"]["group"].to_s + ".json"
  owner "root"
  group "root"
  mode "0644"
#   action :create_if_missing 
  notifies :restart, "service[nglb]", :delayed
end

service "nglb" do
  reload_command "/usr/sbin/logrotate -f /etc/logrotate.d/nglb"
  action [:enable, :start]
#   ignore_failure true 
end

cookbook_file "/etc/logrotate.d/nglb" do
  source "logrotatenglb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :reload, "service[nglb]", :delayed
end
