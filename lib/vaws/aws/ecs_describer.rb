require 'aws-sdk-ecs'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class EcsDescriber < Describer
      def initialize
        @ecs_client = ::Aws::ECS::Client.new
      end

      def terminal_table(opt_tasks:, opt_networks:, opt_services:)
        single_option_validation(opt_tasks, opt_networks, opt_services)
        table = tasks if opt_tasks
        table = networks if opt_networks
        table = services if opt_services
        table = clusters if opt_tasks.nil? && opt_networks.nil? && opt_services.nil?
        table
      end

      private

      def clusters
        rows = []
        cluster_arns.each do |cluster_arn|
          cluster_name     = cluster_arn.gsub(/arn:aws:ecs:#{ENV['AWS_DEFAULT_REGION']}:[0-9]*:cluster\//, "")
          cluster_services = service_arns(cluster_arn).join("\n").gsub(/.*:[0-9]*:service\//, "")

          ecs_cluster           = @ecs_client.describe_clusters({ clusters: ["#{cluster_arn}"] }).clusters
          running_tasks_count   = ecs_cluster[0].running_tasks_count
          pending_tasks_count   = ecs_cluster[0].pending_tasks_count
          active_services_count = ecs_cluster[0].active_services_count

          rows << [cluster_name, active_services_count, running_tasks_count, pending_tasks_count, cluster_services]
        end

        Terminal::Table.new :headings => ['ClusterName', 'ActService', 'RunTask', 'PenTask', 'Services'], :rows => rows.sort
      end

      def tasks
        rows                                                        = []
        lb_target_group                                             = nil
        task, d_count, p_count, r_count, updated_at, sg, c_provider = nil
        cluster_arn                                                 = selected_cluster_arn
        cluster_name                                                = cluster_arn.gsub(/.*:cluster\//, '')
        service_names                                               = service_names(cluster_arn)

        service_names.each_slice(1).to_a.each do |s|
          describe_services(cluster: cluster_name, service_names: s).services.each do |ds|
            ds.load_balancers.each do |lb|
              lb_container_name = lb.container_name
              lb_container_port = lb.container_port
              lb_target_group   = lb.target_group_arn.gsub(/.*:targetgroup\//, '').gsub(/\/.*$/, '')
              lb_target_group << ":#{lb_container_name}:#{lb_container_port}"
            end

            ds.deployments.each do |d|
              task       = d.task_definition.gsub(/.*:task-definition\//, '')
              d_count    = d.desired_count
              p_count    = d.pending_count
              r_count    = d.running_count
              updated_at = d.updated_at
              sg         = d.network_configuration.awsvpc_configuration.security_groups.join(',') if d.network_configuration
              if d.capacity_provider_strategy
                d.capacity_provider_strategy.each do |c|
                  c_provider = c.capacity_provider
                end
              end
            end
            c_provider = ds.launch_type if c_provider.nil?

            rows << [task, d_count, r_count, p_count, lb_target_group, sg, updated_at, c_provider]
            task, d_count, r_count, p_count, lb_target_group, sg, updated_at, c_provider = nil
          end
        end

        Terminal::Table.new :headings => ['TaskDefinition', 'Desired', 'Running', 'Pending', 'LbTargetGroup:Container:Port', 'SecurityGroup', 'UpdatedAt', 'CapacityProvider'], :rows => rows.sort
      end

      def networks
        # TODO
      end

      def services
        # TODO
      end

      def describe_services(cluster:, service_names:)
        @ecs_client.describe_services({
          cluster:  cluster,
          services: service_names,
        })
      end

      def cluster_arns
        param_args = {
          max_results: 100
        }
        @ecs_client.list_clusters(param_args)[:cluster_arns]
      end

      def selected_cluster_arn
        puts "# CLUSTER LIST"
        arns = cluster_arns
        arns.each_with_index do |arn, cnt|
          puts "#{cnt}: #{arn}"
        end
        print "cluster numbner:"
        input = STDIN.gets
        begin
          raise unless /[0-9].*/ =~ input
          input_cluster_number = input.to_i
          arns[input_cluster_number]
        rescue
          puts "Not found cluster"
          exit
        end
      end

      def service_arns(cluster_arn)
        service_ary = []
        service_ary << @ecs_client.list_services({ cluster: "#{cluster_arn}", max_results: 100 })[:service_arns].sort
      end

      def service_names(cluster_arn)
        service_ary = []
        names       = []
        service_ary << @ecs_client.list_services({ cluster: "#{cluster_arn}", max_results: 100 })[:service_arns].sort.each do |arn|
          names << arn.gsub(/.*:[0-9]*:service\//, "")
        end
        names
      end
    end
  end
end