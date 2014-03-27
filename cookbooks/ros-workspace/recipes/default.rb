include_recipe "ros"

workspace_dir = node["ros-workspace"][:dir]
workspace_source_dir = "#{workspace_dir}/src"

## Create the ROS workspace

directory workspace_source_dir do
  user "vagrant"
  recursive true
  action :create
end

execute "wstool init" do
  user "vagrant"
  command "wstool init #{workspace_source_dir} #{node["ros-workspace"][:source_uri]}"
end

execute "wstool update" do
  user "vagrant"
  command "wstool update -t #{workspace_source_dir}"
end

## Build the workspace

bash "catkin_make" do
  user "vagrant"
  environment ({'HOME' => '/home/vagrant', 'USER' => 'vagrant'})
  code <<-EOF
    source /home/vagrant/.ros.bashrc
    catkin_make -C #{workspace_dir}
  EOF
end

## Workspace environment setup

template "/home/vagrant/.ros.bashrc" do
  source "ros.bashrc.erb"
end
