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
        logger.info("# creating fanout (name=#{name})")
        @fanout = channel.fanout(name)
      end

      def publish(o)
        logger.info("> [#{name}]: #{o.inspect}")
        @fanout.publish(MultiJson.encode(o))
      end
    end
  end
end
