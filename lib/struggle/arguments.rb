module Arguments
  def fancy_accessor(*args)
    @__args ||= []
    @__args.push(*args)

    attr_writer(*args)

    # Add an accessor that will delegate to +obj.__value__+ if +obj+
    # responds to +__value__+. Delegated results are not cached.
    #
    # Passing +unbox: false+ to the accessor will always return +obj+.
    args.each do |arg|
      define_method(arg) do |unbox: true|
        return nil unless instance_variable_defined?(:"@#{arg}")

        iv = instance_variable_get(:"@#{arg}")

        unbox && iv.respond_to?(:__value__) ? iv.__value__ : iv
      end
    end
  end

  def arguments
    (defined?(@__args) && @__args) || []
  end
end

class Object
  include Arguments
end
