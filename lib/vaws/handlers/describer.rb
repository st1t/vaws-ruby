require 'thor'
require 'terminal-table'
require 'vaws/aws/ec2_describer'
require 'vaws/aws/alb_describer'

module Vaws
  module Handlers
    class Describer < Thor
      desc 'ec2', 'View EC2 instances'

      def ec2
        ec2_desc = Vaws::Aws::Ec2Describer.new
        ec2_desc.set_basic_info
        puts ec2_desc.term_table
      end

      desc 'alb', 'View Application Loadbalarancers'

      def alb
        alb_desc = Vaws::Aws::AlbDescriber.new
        alb_desc.set_basic_info
        puts alb_desc.term_table
      end
    end
  end
end
Vaws::Handlers::Describer.start(ARGV)