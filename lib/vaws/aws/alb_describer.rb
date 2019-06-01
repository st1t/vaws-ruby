require 'aws-sdk-elasticloadbalancingv2'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class AlbDescriber < Describer
      attr_reader :term_table

      def initialize
        @alb_client = ::Aws::ElasticLoadBalancingV2::Client.new
        @term_table = ''
      end

      def set_basic_info
        rows = []
        albs = @alb_client.describe_load_balancers

        # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ElasticLoadBalancingV2/Client.html#describe_load_balancers-instance_method
        albs.load_balancers.each do |alb|
          arn    = alb.load_balancer_arn.sub!(/arn:aws:elasticloadbalancing:ap-northeast-1:163714994724:loadbalancer\/...\//, '')
          dns    = alb.dns_name
          name   = alb.load_balancer_name
          scheme = alb.scheme
          vpc    = alb.vpc_id
          type   = alb.type

          rows << [name, type, scheme, vpc, arn, dns]
        end
        @term_table = Terminal::Table.new :headings => ['Name', 'Type', 'Scheme', 'Vpc', 'Short_Arn', 'Dns'], :rows => rows
      end
    end
  end
end