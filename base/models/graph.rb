class Graph

  def self.all
    Cfg.graphs
  end

  def self.find_by_url graph_url
    index = Graph.all.map{|g| g[:url]}.index(graph_url)
    index.nil? ? nil : Graph.all[index]
  end
end
