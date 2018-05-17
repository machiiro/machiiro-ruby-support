module MachiiroSupport
  module Database
    class << self
      def databases(connection = ActiveRecord::Base.connection)
        connection.execute('SHOW DATABASES').map { |e| e[0] }
      end

      def connection_foreign_key_disable(connection = ActiveRecord::Base.connection)
        connection.execute('SET FOREIGN_KEY_CHECKS = 0')
        begin
          yield(connection)
        ensure
          connection.execute('SET FOREIGN_KEY_CHECKS = 1')
        end
      end

      def cp_status
        pool = ActiveRecord::Base.connection_pool.instance_eval { @available }
        connections = ActiveRecord::Base.connection_pool.instance_eval { @connections }
      
        {
          max: ActiveRecord::Base.connection_pool.size,
          total: connections.size,
          busy: connections.count {|c| c.in_use? },
          dead: connections.count {|c| c.in_use? && !c.owner.alive? },
          num_waiting: pool.num_waiting,
          checkout_timeout: ActiveRecord::Base.connection_pool.checkout_timeout
        }
      end
    end
  end
end