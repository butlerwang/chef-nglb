###############################

# File Name : nginx.rb

# Purpose :

# Creation Date : 06-15-2017

# Last Modified : Tue Jun 20 11:16:34 2017

# Created By : Kiyor

###############################

package "ccna-nginx-ssl" do
  version "1.10.2-0"
  action :install
  allow_downgrade true
end

cookbook_file "/etc/init.d/nginx" do
  source "init_nginx"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/usr/local/nginx/conf/nginx.conf" do
  source "nginx.conf.erb"
  mode "0644"
  notifies :restart, "service[nginx]", :delayed
end

cookbook_file "/usr/local/nginx/conf/stream.conf" do
  source "stream.conf"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
  notifies :restart, "service[nginx]", :delayed
end

service "nginx" do
  action [:enable, :start]
end
