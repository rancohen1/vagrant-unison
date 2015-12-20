require "vagrant"
module VagrantPlugins
  module Unison
    module UnisonSync
      include Vagrant::Action::Builtin::MixinSyncedFolders
      def execute_sync_command(machine)
        folder_opts = synced_folders(machine)[:unison].values.first

        machine.ui.info "Unisoning changes from {host}::#{folder_opts[:hostpath]} --> {guest VM}::#{folder_opts[:guestpath]}"

        # Create the guest path
        machine.communicate.sudo("mkdir -p '#{folder_opts[:guestpath]}'")
        machine.communicate.sudo("chown #{machine.ssh_info[:username]} '#{folder_opts[:guestpath]}'")

        ssh_command = SshCommand.new(machine, folder_opts)
        shell_command = ShellCommand.new(machine, folder_opts, ssh_command)

        yield shell_command
      end
    end
  end
end
