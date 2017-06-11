require 'multi_json'
require_relative './rabbit'

module XA
  module Messages
    class DirectPublisher < Rabbit
      def self.for(name)
        pub = DirectPublisher.new(name)
        pub.up
        yield(pub)
        pub.down
      end
      
      def up
        super
        logger.info("# creating direct (name=#{name})")
        @ex = channel.direct(name, durable: true)
      end

      def publish(target, o)
        logger.info("> [#{name}]: #{o.inspect}")
        @ex.publish(MultiJson.encode(o), routing_key: target)
      end
    end
  end
end
