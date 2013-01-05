module GameKeeper
  class Nagios

    NODE  = "rabbitmq_node"
    QUEUE = "rabbitmq_queue"

    CHECK_KEYS = ['messages', 'memory']

    def initialize(settings, checks = {})
      @settings, @checks = settings, checks
    end

    def nrpe_entries
      @entries ||= {
        NODE  => nrpe_entry(:node),
        QUEUE => nrpe_entry(:queue)
      }
    end

    def service_checks
      @expanded ||= @checks.inject({}) do |hash, (k, v)|
        ensure_keys(CHECK_KEYS, v)

        check = v['check'] || QUEUE
        name  = v['name']  || k
        args  = [name, v['messages'], v['memory']].flatten

        hash[k] = {
          'check_command' => check_command(check, args)
        }

        hash
      end
    end

    private

    def nrpe_entry(mode)
      <<-CHECK.gsub(/\s+/, " ").strip
        #{@settings.bin} check #{mode}
          --uri      #{@settings.uri}
          --name     $ARG1$
          --messages $ARG2$,$ARG3$
          --memory   $ARG4$,$ARG5$
      CHECK
    end

    def check_command(name, args)
      args.each_with_index do |v, i|
        throw "check_nrpe!#{name} argument #{i + 1} is nil" if v.nil?
      end

      "check_nrpe!#{name} -a #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]}"
    end

    def ensure_keys(expected, hash)
      actual = hash.keys

      expected.each do |k|
        unless actual.include?(k)
          throw "Invalid check: #{k} not specified in #{hash.inspect}"
        end
      end
    end

  end
end
