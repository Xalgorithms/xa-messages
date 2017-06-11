require 'multi_json'
require_relative './rabbit'

module XA
  module Messages
    class Publisher < Rabbit
      def self.for(name)
        pub = Publisher.new(name)
        pub.up
        yield(pub)
        pub.down
      end
      
      def up
        super
        logger.info("# creating direct (name=#{name})")
        @exchange = channel.direct(name)
      end

      def publish(o)
        logger.info("> [#{name}]: #{o.inspect}")
        @exchange.publish(MultiJson.encode(o))
      end
    end
  end
end
