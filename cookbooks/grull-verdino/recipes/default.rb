include_recipe "git"
include_recipe "github"

local_repository = "#{Chef::Config[:file_cache_path]}/grull-verdino"
source_rosinstall = "#{local_repository}/#{node["grull-verdino"][:rosinstall_path]}"
target_rosinstall = "#{node["ros-workspace"][:dir]}/src/#{node["grull-verdino"][:rosinstall_path]}"

## Install dependencies

package "ros-hydro-realtime-tools" do
  action :install
end

package "ros-hydro-ackermann-msgs" do
  action :install
end

## Download GRULL Verdino ROS rosinstall files

git local_repository do
  repository node["grull-verdino"][:install_repository]
  action :checkout
end

## Prepare rosinstall file (e.g., convert Github HTTPS URIs to SSH)
## copy to ROS workspace and create it.

bash "prepare-rosinstall" do
  user "vagrant"
  code <<-EOF
    sed 's/http[s]*:\\/\\/github\.com\\//git@github.com:/' #{source_rosinstall} > #{target_rosinstall}
  EOF
  subscribes :run, "execute[wstool init]", :immediately
  action :nothing
end

include_recipe "ros-workspace"

## Environment setup for Gazebo

template "/home/vagrant/.ros.bashrc" do
  source "ros.bashrc.erb"
end
