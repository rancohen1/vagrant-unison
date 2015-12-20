module VagrantPlugins
  module Unison
    class ShellCommand
      def initialize machine, folder_opts, ssh_command
        @machine = machine
        @folder_opts = folder_opts
        @ssh_command = ssh_command
      end

      attr_accessor :batch, :repeat, :terse

      def to_a
        args.map do |arg|
          arg = arg[1...-1] if arg =~ /\A"(.*)"\z/
          arg
        end
      end

      def to_s
        args.join(' ')
      end

      private

      def args
        [
          'unison',
          @folder_opts[:hostpath],
          @ssh_command.uri,
          batch_arg,
          terse_arg,
          repeat_arg,
          ignore_arg,
          ['-sshargs', %("#{@ssh_command.command}")],
        ].flatten.compact
      end

      def batch_arg
        '-batch' if batch
      end

      def ignore_arg
       ['-ignore', %("Name {#{( (@folder_opts[:ignore] || []) + ['.vagrant']).join(",")}}")]
      end

      def repeat_arg
        ['-repeat', @folder_opts[:repeat]] if repeat && @folder_opts[:repeat]
      end

      def terse_arg
        '-terse' if terse
      end
    end
  end
end
