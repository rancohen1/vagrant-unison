require "vagrant/util/which"

module VagrantPlugins
    module Unison
        class SyncedFolder < Vagrant.plugin("2", :synced_folder)
           include Vagrant::Util

           def usable?(machine, raise_error=false)
              unison_path = Which.which("unison")
              return true if unison_path
              return false if !raise_error
              raise "Can't find unison on host"
           end

           def prepare(machine, folders, opts)
               # Nothing...
           end

           def enable(machine, folders, opts)
               if ((machine.communicate.sudo "which unison", error_check: false) != 0)
                   if ((machine.communicate.sudo "apt-get install -q unison", error_check: false) != 0)
                       raise "Could not install unison on host";
                   end
               end
               require_relative "command"
               folders.each do |id, folder_opts|
                   Command.new([],"").sync(machine, { :hostpath => folder_opts[:hostpath], :guestpath => folder_opts[:guestpath] })
               end
           end
           
        end
    end
end

