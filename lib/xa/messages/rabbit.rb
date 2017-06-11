require 'bunny'

module XA
  module Messages
    class Rabbit
      def initialize(name)
        @name = name
      end
      
      def logger
        $stdout.sync = true
        @logger ||= Logger.new($stdout)
      end

      def up
        user = ENV.fetch('RABBITMQ_USER', 'admin')
        host = ENV.fetch('RABBITMQ_HOST', 'mq')
        
        logger.info("# connecting to MQ (user=#{user}; host=#{host})")
        @conn = Bunny.new(
          user: user,
          password: ENV.fetch('RABBITMQ_PASS', ''),
          hostname: host)

        logger.info('# starting channel')
        @conn.start
        @channel = @conn.create_channel
      end

      def down
        logger.info('# closing channel')
        @channel.close if @channel
        @conn.close if @conn
      end

      protected

      def channel
        @channel
      end

      def name
        @name
      end
    end
  end
end
