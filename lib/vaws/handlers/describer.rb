require 'thor'
require 'terminal-table'
require 'vaws/aws/ec2_describer'
require 'vaws/aws/alb_describer'
require 'vaws/aws/subnet_describer'
require 'vaws/aws/vpc_describer'
require 'vaws/aws/ecs_describer'
require 'vaws/aws/route53_describer'
require 'vaws/aws/security_group_describer'
require 'vaws/aws/acm_describer'
require 'vaws/aws/ssm_describer'

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

      desc 'subnet', 'View Subnet'

      def subnet
        subnet_desc = Vaws::Aws::SubnetDescriber.new
        subnet_desc.set_basic_info
        puts subnet_desc.term_table
      end

      desc 'vpc', 'View Vpc'

      def vpc
        vpc_desc = Vaws::Aws::VpcDescriber.new
        vpc_desc.set_basic_info
        puts vpc_desc.term_table
      end

      desc 'ecs', 'View ECS'

      def ecs
        ecs_desc = Vaws::Aws::EcsDescriber.new
        ecs_desc.set_basic_info
        puts ecs_desc.term_table
      end

      desc 'route53', 'View Route53'

      def route53
        r53_desc = Vaws::Aws::Route53Describer.new
        r53_desc.set_basic_info
        puts r53_desc.term_table
      end

      desc 'sg', 'View Security Group'
      def sg
        sg_desc = Vaws::Aws::SecurityGroupDescriber.new
        sg_desc.set_basic_info
        puts sg_desc.term_table
      end

      desc 'acm', 'View ACM'

      def acm
        acm_desc = Vaws::Aws::AcmDescriber.new
        acm_desc.set_basic_info
        puts acm_desc.term_table
      end

      desc 'ssm', 'View SSM Parameter store'

      def ssm
        ssm_desc = Vaws::Aws::SsmDescriber.new
        ssm_desc.set_basic_info
        puts ssm_desc.term_table
      end
    end
  end
end
Vaws::Handlers::Describer.start(ARGV)