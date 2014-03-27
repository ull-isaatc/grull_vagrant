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

execute "rosdep init" do
  user "root"
  not_if do ::File.exists?("/etc/ros/rosdep/sources.list.d/20-default.list") end
end

execute "rosdep update" do
  user "vagrant"
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
end

## Environment setup

template "/home/vagrant/.ros.bashrc" do
  source "ros.bashrc.erb"
end

ruby_block "insert_source_ros.bashrc" do
  block do
    newlines = <<-EOF
      # setup your ROS environment
      source ~/.ros.bashrc
    EOF
    file = Chef::Util::FileEdit.new("/home/vagrant/.bashrc")
    file.insert_line_if_no_match("^# setup your ROS environment", newlines)
    file.write_file
  end
end
