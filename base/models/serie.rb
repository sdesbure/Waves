class Serie
  attr_reader :name, :type
  def initialize params
    @name = params[:name]
    @host = params[:host]
    @path = params[:path]
    @type = params[:type]
    @rrd = RRD::Base.new path
  end

  def last_values
    fetch_escaped( :average, Time.now - 1.hour, Time.now)[0..-3]
  end

  def values start=nil
    start ||= Time.now - 1.hour
    fetch_escaped(:average, start, Time.now)[0..-3]
  end

  private
  def fetch type, start_time, end_time
    @rrd.fetch(:average, :start => start_time, :end => end_time)[1..-1]
  end

  def fetch_escaped type, start_time, end_time
    fetch(type, start_time, end_time).map{|value| value.last.nan? ? [value.first * 1000, 0.0] : [value.first * 1000, value.last]}
  end

  def path
    File.join Cfg.collectd_path, 'rrd', @host, "#{@path}.rrd"
  end
end
