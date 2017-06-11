require 'multi_json'
require_relative './rabbit'

module XA
  module Messages
    class Subscriber < Rabbit
      def up(&bl)
        super

        logger.info("# connecting to fanout (name=#{name})")
        fo = channel.fanout(name)
        q = channel.queue('', exclusive: true)
        q.bind(fo)

        logger.info('# subscribing')
        q.subscribe(block: true) do |di, props, body|
          o = MultiJson.decode(body)
          logger.info("< [#{name}]: #{o.inspect}")
          bl.call(o) if bl
        end
      end
    end
  end
end
