require 'aws-sdk-ec2'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class Ec2Describer < Describer
      attr_reader :term_table

      def initialize
        @ec2_client = ::Aws::EC2::Client.new
        @tag        = 'No Name'
        @term_table = ''
      end

      def set_basic_info
        rows       = []
        next_token = nil
        sg_ids     = ""

        begin
          param_args              = {
            max_results: 1000
          }
          param_args[:next_token] = next_token if next_token
          resp                    = @ec2_client.describe_instances(param_args)
          resp[:reservations].each do |reservation|
            reservation.instances.each do |instance|
              instance.tags.each do |tag|
                @tag = tag.value if tag.key == 'Name'
              end
              instance.security_groups.each_with_index do |sg, index|
                sg_ids << "#{sg.group_id}, "
                sg_ids = sg_ids.gsub(/, $/, '') if index == instance.security_groups.size - 1
              end
              instance_id   = instance.instance_id
              instance_type = instance.instance_type
              public_ip     = instance.public_ip_address
              private_ip    = instance.private_ip_address
              state_name    = instance.state.name
              rows << [@tag, instance_id, instance_type, public_ip, private_ip, state_name, sg_ids]
              sg_ids = ''
            end
          end
          next_token = resp.next_token
        end while next_token
        @term_table = Terminal::Table.new :headings => ['Name', 'Id', 'Type', 'GlobalIp', 'PrivateIp', 'Status', 'SecurityGroupId'], :rows => rows.sort
      end
    end
  end
end