module Leap
  module DeliberationsAccessor
    def deliberations
      @deliberations ||= Hash.new do |h, k|
        return nil unless respond_to? k
        send k
        h[k]
      end
    end
  end
end
      

