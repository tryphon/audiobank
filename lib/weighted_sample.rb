class FixedWeightedSampler

  def initialize(weighted_items = {})
    @weighted_items = weighted_items
  end

  def push(item, weight = 1)
    @weighted_items[item] = weight
    reset!
    self
  end

  def concat(items = {})
    @weighted_items.merge(items)
    reset!
    self
  end

  def prepare
    unless @weights
      @total = 0

      @items, @weights =
              unless @weighted_items.empty?
                sorted_weighted_items = @weighted_items.sort_by do |item, weight|
                  @total += weight
                  weight
                end
                sorted_weighted_items.transpose
              else
                [[], []]
              end
    end

    self
  end

  def reset!
    @weights = nil
  end

  def sample
    return nil if @weighted_items.empty?

    prepare

    trigger = Kernel::rand * @total
    load = 0

    @weights.each_with_index do |weight, index|
      load += weight
      return @items[index] if load > trigger
    end

    @items.last
  end

end
