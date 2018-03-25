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
    end
  end
end