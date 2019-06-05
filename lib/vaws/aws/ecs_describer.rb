require 'aws-sdk-ecs'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class EcsDescriber < Describer
      attr_reader :term_table

      def initialize
        @ecs_client   = ::Aws::ECS::Client.new
        @term_table   = ''
        @cluster_arns = []
        @cluster_info = {}
      end

      def set_basic_info
        get_cluster_arns

        rows = []
        @cluster_arns.each do |cluster_arn|
          cluster_name = cluster_arn.gsub(/arn:aws:ecs:#{ENV['AWS_DEFAULT_REGION']}:[0-9]*:cluster\//, "")
          @cluster_info.store("#{cluster_name}", {})
          cluster_name     = "#{cluster_name}"
          cluster_services = get_service_names(cluster_arn)

          ecs_cluster           = @ecs_client.describe_clusters({ clusters: ["#{cluster_arn}"] }).clusters
          running_tasks_count   = ecs_cluster[0].running_tasks_count
          pending_tasks_count   = ecs_cluster[0].pending_tasks_count
          active_services_count = ecs_cluster[0].active_services_count

          rows << [cluster_name, cluster_services, active_services_count, running_tasks_count, pending_tasks_count]
        end

        @term_table = Terminal::Table.new :headings => ['ClusterName', 'Services', 'ActService', 'RunTask', 'PenTask'], :rows => rows.sort
      end

      private

      def get_cluster_arns
        @cluster_arns = @ecs_client.list_clusters[:cluster_arns]
      end

      def get_service_arns(cluster_arn)
        return @ecs_client.list_services({ cluster: "#{cluster_arn}" })[:service_arns]
      end

      def get_service_names(cluster_arn)
        service_ary = @ecs_client.list_services({ cluster: "#{cluster_arn}", max_results: 100 })[:service_arns]
        return service_ary.join(",").gsub(/arn:aws:ecs:#{ENV['AWS_DEFAULT_REGION']}:[0-9]*:service\//, "")
      end
    end
  end
end