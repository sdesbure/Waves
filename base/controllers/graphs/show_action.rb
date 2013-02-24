class Graphs
  # put here action-specific setups
  def show graph
    @graph = Graph.find_by_url graph
    render
  end
end
