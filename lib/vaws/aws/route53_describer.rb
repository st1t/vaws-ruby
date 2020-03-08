require 'aws-sdk-route53'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class Route53Describer < Describer
      attr_reader :term_table

      def initialize
        @r53_client          = ::Aws::Route53::Client.new
        @r53_hosted_zone_ids = []
        @term_table          = ''
      end

      def set_basic_info
        rows = []

        zone_id                = selected_zone_id
        record_values          = ''
        next_record_identifier = nil
        next_record_name       = nil
        next_record_type       = nil

        begin
          param_args                           = {
            hosted_zone_id: zone_id,
            max_items:      200
          }
          param_args[:start_record_identifier] = next_record_identifier if next_record_identifier
          param_args[:start_record_name]       = next_record_name if next_record_name
          param_args[:start_record_type]       = next_record_type if next_record_type
          resp                                 = @r53_client.list_resource_record_sets(param_args)

          resp.resource_record_sets.each do |record_set|
            name = record_set.name
            type = record_set.type
            ttl  = record_set.ttl
            if record_set.alias_target.nil?
              record_set.resource_records.each do |record|
                record_values << "#{record.value.to_s}\n"
              end
            else
              record_values = record_set.alias_target.dns_name
            end
            rows << [name, type, record_values, ttl]
            record_values = ''
          end
          next_record_identifier = resp.next_record_identifier
          next_record_name       = resp.next_record_name
          next_record_type       = resp.next_record_type
        end while next_record_identifier
        @term_table = Terminal::Table.new :headings => ['Fqdn', 'Type', 'Value', 'Ttl'], :rows => rows.sort
      end


      private

      def selected_zone_id
        puts "# ZONE LIST"
        zones = hosted_zones
        zones.each_with_index do |zone, cnt|
          puts "#{cnt}:#{zone[:name]}"
        end
        print "zone number: "
        input = STDIN.gets
        begin
          raise unless /[0-9].*/ =~ input
          input_zone_number = input.to_i
          zones[input_zone_number][:id] if zones[input_zone_number][:id]
        rescue
          puts "Not found zone"
          return
        end
      end

      def hosted_zones
        param_args = {
          max_items: 100
        }
        @r53_client.list_hosted_zones(param_args).hosted_zones.each do |zone|
          @r53_hosted_zone_ids << zone.id
        end
      end
    end
  end
end