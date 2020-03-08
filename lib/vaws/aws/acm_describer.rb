require 'aws-sdk-acm'
require 'vaws/aws/describer'

module Vaws
  module Aws
    class AcmDescriber < Describer
      attr_reader :term_table

      def initialize
        @acm_client = ::Aws::ACM::Client.new
        @term_table = ''
      end

      def set_basic_info
        rows       = []
        next_token = nil

        begin
          param_args              = {
            max_items: 1000
          }
          param_args[:next_token] = next_token if next_token
          resp                    = @acm_client.list_certificates(param_args)
          resp.certificate_summary_list.each do |cert|
            cert_arn    = cert.certificate_arn
            cert_domain = cert.domain_name
            rows << [cert_domain, cert_arn]
          end
          next_token = resp.next_token
        end while next_token
        @term_table = Terminal::Table.new :headings => ['Domain', 'Arn'], :rows => rows.sort
      end
    end
  end
end