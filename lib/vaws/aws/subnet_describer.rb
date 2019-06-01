require 'aws-sdk-ec2'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class SubnetDescriber < Describer
      attr_reader :term_table

      def initialize
        @subnet_client = ::Aws::EC2::Client.new
        @term_table    = ''
      end

      def set_basic_info
        rows    = []
        subnets = @subnet_client.describe_subnets
        subnets.subnets.each do |subnet|
          az        = subnet.availability_zone
          cidr      = subnet.cidr_block
          subnet_id = subnet.subnet_id
          vpc_id    = subnet.vpc_id

          rows << [cidr, subnet_id, az, vpc_id]
        end
        @term_table = Terminal::Table.new :headings => ['Cidr', 'SubnetId', 'Az', 'VpcId'], :rows => rows
      end
    end
  end
end