
Vagrant.configure(2) do |config|
  config.vm.box = "williamyeh/ubuntu-trusty64-docker"
  config.vm.box_version = "= 1.8.3.20151019"
  
  config.vm.provision "shell", inline: <<-SHELL
    docker pull ruby:2.0
    docker run --name temp ruby:2.0 /bin/bash  -c "yes | gem uninstall bundler; gem install bundler -v 1.10.6;"
    docker commit temp local/ruby:2.0
    docker rm -f temp
    docker rm -f build || true
  SHELL
  
  config.vm.provision "docker", run: "always" do |d|
    d.run "build",
	  image: "local/ruby:2.0",
	  daemonize: false,
      restart: "no",
	  args: "-w /usr/src/app -v /vagrant:/usr/src/app",
	  cmd: "/bin/bash -c \"bundle install; rake build\""
  end
end
