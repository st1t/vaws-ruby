require 'aws-sdk-ssm'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class SsmDescriber < Describer
      attr_reader :term_table

      def initialize
        @ssm_client = ::Aws::SSM::Client.new
        @term_table = ''
      end

      def set_basic_info
        rows   = []
        params = @ssm_client.describe_parameters({ max_results: 50 })

        params.parameters.each do |param|
          name             = param.name
          type             = param.type
          version          = param.version
          last_modify_date = param.last_modified_date

          rows << [name, type, version, last_modify_date]
        end
        @term_table = Terminal::Table.new :headings => ['Path', 'Type', 'Version', 'LastModifyDate'], :rows => rows.sort
      end
    end
  end
end