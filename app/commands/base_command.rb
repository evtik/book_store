class BaseCommand
  include Wisper::Publisher

  class << self
    def call(*args, &block)
      command = build
      command.evaluate(&block) if block_given?
      command.call(*args)
    end

    def build
      new
    end
  end

  def evaluate(&block)
    @caller = eval('self', block.binding)
    instance_eval(&block)
  end

  def method_missing(method_name, *args, &block)
    if @caller.respond_to?(method_name, true)
      @caller.send(method_name, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @caller.respond_to?(method_name, include_private)
  end
end
