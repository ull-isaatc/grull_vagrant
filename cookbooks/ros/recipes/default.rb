## Setup sources.list

apt_repository "ros-packages" do
  uri "http://packages.ros.org/ros/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  key "http://packages.ros.org/ros.key"
end

## Full install

package "ros-#{node[:ros][:release]}-desktop-full" do
  action :install
end

package "python-rosinstall" do
  action :install
end

## Initialize rosdep

##execute "rosdep init" do
##  user "root"
##  not_if do ::File.exists?("/etc/ros/rosdep/sources.list.d/20-default.list") end
##end

##execute "rosdep update" do
##  user "vagrant"
##end

## Environment setup

template "#{node[:ros][:bash_profile_dir]}/ros_setup.sh" do
  source "ros_setup.sh.erb"
end
