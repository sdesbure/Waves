class Graphs
  # put here action-specific setups
  def index graph = nil
    if graph.nil?
      @graphs = Graph.all
      render
    else
      show graph
    end
  end
end
