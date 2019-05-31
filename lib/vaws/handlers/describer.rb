require 'thor'
require 'terminal-table'
require 'vaws/aws/ec2_describer'

module Vaws
  module Handlers
    class Describer < Thor
      desc 'ec2', 'View ec2 instances'

      def ec2
        ec2_desc = Vaws::Aws::Ec2Describer.new
        ec2_desc.set_basic_info
        puts ec2_desc.term_table
      end
    end
  end
end
Vaws::Handlers::Describer.start(ARGV)