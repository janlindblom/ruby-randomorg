module RandomOrg
  module Response
    # Integers response from Random.org API.
    #
    # @version 0.2.2
    # @author Jan Lindblom <janlindblom@fastmail.fm>
    # @!attribute [rw] data
    #   @return [Array] an array containing the sequence of numbers requested.
    class IntegerSequences
      attr_accessor :data
      attr_accessor :completion_time

      def initialize(args = {})
        Response.convert_hash_keys(args).each {|k,v| public_send("#{k}=",v)}
      end

      def completion_time=(completion_time)
        if completion_time.is_a? String
          @completion_time = DateTime.parse completion_time
        else
          @completion_time = completion_time
        end
      end
    end
  end
end
