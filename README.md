# grull-vagrant

Vagrantfile and Chef recipes for setting up ROS and GRULL Verdino ROS packages
in a Vagrant virtual machine.

## About Vagrant and Chef

Vagrant is a tool to create and configure reproducible and portable development
environments using virtual machines. These are specified through Vagrantfiles,
in a similar manner as ```make``` uses Makefiles.

The created virtual machines must be provisioned with all the software that
we need. So here is where we need Chef, a configuration management tool written
in Ruby.

Chef is a tool used to streamline the task of configuring and maintaining
company's servers, so the same recipes can be used to automatically provision
and configure real machines, no only virtual machinen used in development.

## Requirements

Mainly, you need Vagrant and some additional plugins:

 * Virtualbox (our Vagrantfile has only been tested with this VM provider)
 * Vagrant >= 1.5
 * Vagrant-librarian-chef
 * Vagrant-omnibus (optional, if we are to use a Vagrant box with Chef
pre-installed. That is not the case with the default box in our Vagrantfile)

Vagrant-librarin-chef and vagrant-omnibus plugins could be easily installed from
Vagrant running:

    $ vagrant plugin install vagrant-omnibus
    $ vagrant plugin install vagrant-librarian-chef

from command line.

## Software provisioned

By default, the next lines in the Vagrantfile will install and configure
Ubuntu Desktop and ROS:

```ruby
    chef.add_recipe "apt"
    ...
    chef.add_recipe "ubuntu-desktop"
    chef.add_recipe "vim-default-editor"
    # install ROS packages
    chef.add_recipe "ros"
```

If you want a ROS development environment with Kdevelop and a workspace
initilized at ```/vagrant/ROS/isaatc-ULL```, we have to uncomment the next line
to add the role ```devel```:

```ruby
    chef.add_role "devel"
```

Finally, if you want a full GRULL Verdino ROS development environment, with all
Verdino ROS packages downloaded to the workspace, you have to add the recipe ```grull-verdino```:

```ruby
    chef.add_recipe "grull-verdino"
```

The ```rosinstall``` file used will be:

 * ```.rosinstall```, if only the recipe ```grull-verdino``` was added.
 * ```devel.rosinstall```, if both the recipe ```grull-verdino``` and the role
```devel``` were added.

but you can override that behavior adding:

```ruby
    "grull-verdino" => {
      "rosinstall_path" => ".rosinstall"
    }
```

to ````chef.json```` in the Vagrantfile.

## Downloads from private repositories on Github

The recipe ```grull-verdino``` use SSH to download GRULL Verdino packages from
Github. Because provisioning is a non-interactive task, you must have configured
the access to Github using SSH key passphrases.

The SSH agent forwarding is enabled in the Vagrantfile 

```ruby
    config.ssh.forward_agent = true
```
so you only have to add your key to the SSH agent

    $ ssh-add

before build a new virtual machine.

## Build a virtual machine

To create the Vagrant virtual machine, just run:

    $ vagrant up 

from the directory of this repository.
