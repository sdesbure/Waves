class Graphs
  # put here action-specific setups
  before :series do
    engine :Yajl
  end

  format_for :series, '.json'

  def series graph, id=nil, start=nil
    @id = id.nil? ? 0 : id.to_i
    @start = start.nil? ? Time.now - 1.hour : Time.strptime(start,'%s')
    graph = Graph.find_by_url graph
    content_type '.json'
    @serie = graph.nil? ? nil : Serie.new(graph[:series][@id])
    render_partial
  end
end
