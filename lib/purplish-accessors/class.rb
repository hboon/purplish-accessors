class Class
  def private_attr_accessor(*attr)
    attr_accessor(*attr)
    private(*attr)
    attr.each { |e| private("#{e}=".to_sym) }
  end

  def private_bool_attr_accessor(*attr)
    method_names = bool_attr_accessor(*attr)
    classes = method_names.map(&:class)
    private(*method_names)
  end

  # Returns the list of method names (symbols) generated. Useful for making them private
  def bool_attr_accessor(*my_accessors)
    method_names = []
    my_accessors.each do |accessor|
      name = ("#{accessor}?").to_sym
      method_names << name
      define_method(name) do
        !!instance_variable_get("@#{accessor}") #rubocop:disable DoubleNegation
      end

      name = "#{accessor}=".to_sym
      method_names << name
      define_method(name) do |accessor_value|
        instance_variable_set("@#{accessor}", accessor_value)
      end
    end
    method_names
  end

  def block_attr_accessor(*my_accessors)
    my_accessors.each do |accessor|
      define_method(accessor) do
        instance_variable_get("@#{accessor}")
      end

      define_method("#{accessor}=") do |accessor_value|
        instance_variable_set("@#{accessor}", accessor_value ? accessor_value.weak! : nil)
      end
    end
  end

  def symbol_attr_accessor(*my_accessors)
    my_accessors.each do |accessor|
      define_method(accessor) do
        instance_variable_get("@#{accessor}")
      end

      define_method("#{accessor}=") do |accessor_value|
        instance_variable_set("@#{accessor}", accessor_value.to_sym)
      end
    end
  end
end
