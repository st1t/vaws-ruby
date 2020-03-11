module Vaws
  module Aws
    class Describer
      #TODO Add def to confirm AWS credential

      # 単一のオプションしか許可されていないコマンドのオプション数を確認
      def single_option_validation(*options)
        options_count = options.length - options.count(nil)
        if options_count > 1
          puts "Can't specify more than one option"
          exit 1
        end
      end
    end
  end
end