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
        get_hosted_zone

        @r53_hosted_zone_ids.each do |zone_id|
          csv_record   = []
          record_alias = ''
          records      = @r53_client.list_resource_record_sets({ hosted_zone_id: "#{zone_id}", max_items: 1000 })
          records.resource_record_sets.each do |record_sets|
            record_name  = record_sets.name
            record_type  = record_sets.type
            record_ttl   = record_sets.ttl
            record_alias = record_sets.alias_target.dns_name if !record_sets.alias_target.nil?
            record_sets.resource_records.each do |record|
              csv_record << record.value
            end
            rows << [record_name, record_type, csv_record, record_ttl, record_alias]
            csv_record   = []
            record_alias = ''
          end
        end
        @term_table = Terminal::Table.new :headings => ['Fqdn', 'Type', 'Value', 'Ttl', 'Alias'], :rows => rows.sort
      end

      private

      def get_hosted_zone
        @r53_client.list_hosted_zones({ max_items: 1000 }).hosted_zones.each do |zone|
          @r53_hosted_zone_ids << zone.id
        end
      end
    end
  end
end