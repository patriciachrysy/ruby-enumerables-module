#!/home/manezeu/.rbenv/shims/ruby

# rubocop:disable Style/CaseEquality
module Enumerable
    def my_each
        case self.class
            when Array
                for item in self
                    yield(item)
                end
            when Hash
                for item in self.keys
                    yield(item, self[item])
                end
        end
        self
    end
end
# rubocop:enable Style/CaseEquality