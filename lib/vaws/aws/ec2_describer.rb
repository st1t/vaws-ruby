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
        rows             = []
        sg_ids           = ""
        ec2_reservations = @ec2_client.describe_instances.reservations
        ec2_reservations.each do |ec2_rsvn|
          ec2_rsvn.instances.each do |ec2_instance|
            ec2_instance.tags.each do |tag|
              @tag = tag.value if tag.key == 'Name'
            end
            ec2_instance.security_groups.each_with_index do |sg, index|
              sg_ids << "#{sg.group_id}, "
              sg_ids = sg_ids.gsub(/, $/, '') if index == ec2_instance.security_groups.size - 1
            end
            instance_id   = ec2_instance.instance_id
            instance_type = ec2_instance.instance_type
            public_ip     = ec2_instance.public_ip_address
            private_ip    = ec2_instance.private_ip_address
            state_name    = ec2_instance.state.name
            rows << [@tag, instance_id, instance_type, public_ip, private_ip, state_name, sg_ids]
            sg_ids = ''
          end
        end
        @term_table = Terminal::Table.new :headings => ['Name', 'Id', 'Type', 'GlobalIp', 'PrivateIp', 'Status','SecurityGroupId'], :rows => rows.sort
      end
    end
  end
end