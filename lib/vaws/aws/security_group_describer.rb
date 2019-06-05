require 'aws-sdk-ec2'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class SecurityGroupDescriber < Describer
      attr_reader :term_table

      def initialize(is_in, is_out)
        @ec2_client = ::Aws::EC2::Client.new
        @term_table = ''
        @is_in      = is_in
        @is_out     = is_out
      end

      def set_basic_info
        rows    = []
        resp_sg = @ec2_client.describe_security_groups

        resp_sg.security_groups.each do |security_group|
          group_name = security_group.group_name
          group_id   = security_group.group_id

          security_group.ip_permissions.each do |ip_permission|
            ip_permission.from_port.nil? ? from_port = "ALL" : from_port = ip_permission.from_port
            ip_permission.ip_protocol == "-1" ? ip_protocol = "ALL" : ip_protocol = ip_permission.ip_protocol

            ip_permission.ip_ranges.each do |ip_range|
              cidr_ip = ip_range.cidr_ip
              rows << [group_name, group_id, cidr_ip, from_port, ip_protocol]
            end
          end
        end
        @term_table = Terminal::Table.new :headings => ['Name', 'Id', 'FromCidr', 'ToPort', 'Protocol'], :rows => rows.sort
      end
    end
  end
end