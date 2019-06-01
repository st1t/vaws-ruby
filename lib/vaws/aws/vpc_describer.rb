require 'aws-sdk-ec2'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class VpcDescriber < Describer
      attr_reader :term_table

      def initialize
        @vpc_client = ::Aws::EC2::Client.new
        @term_table = ''
      end

      def set_basic_info
        rows = []
        vpcs = @vpc_client.describe_vpcs

        vpcs.vpcs.each do |vpc|
          cidr   = vpc.cidr_block
          vpc_id = vpc.vpc_id

          tags = ''
          vpc.tags.each_with_index do |tag, index|
            tags << "#{tag.value}, "
            tags = tags.gsub(/, $/, '') if index == vpc.tags.size - 1
          end

          rows << [vpc_id, cidr, tags]
        end
        @term_table = Terminal::Table.new :headings => ['VpcId', 'Cidr', 'Tags'], :rows => rows
      end
    end
  end
end