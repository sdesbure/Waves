$ ->
  $('.time-select').change () ->
    console.log $(this).val()
    chart = $(this).parent().parent().find('.charts-container').first()
    nb_series = parseInt($(chart).attr('data-number'))
    nb_series_to_zero = nb_series - 1
    base_url = $(chart).attr('data-source')
    for number in [0..nb_series_to_zero]
      $.getJSON(base_url + "/" + number + "/" + $(this).val() + ".json", 
        (data) ->
          $(chart).highcharts().series[data.number].setData(data.values)
      )


  for container in $('.charts-container')
    chart = new Highcharts.Chart({
      chart: {
        renderTo: $(container).attr('id')
        type: 'spline'
        alignTicks: false
      }
      title: {
        text: $(container).attr('data-title')
      }
      xAxis: {
        type: 'datetime'
      }
      yAxis: [
        {
          type: 'linear'
          title:  {
            text: $(container).attr('data-yaxis0')
          }
        }
        {
          min: 100
          max: 1000
          type: 'linear'
          opposite: true
          title: {
            text: $(container).attr('data-yaxis1')
          }
          gridLineWidth: 0
          startOnTick: false
        }
      ]
      series: []
    })
    nb_series = parseInt($(container).attr('data-number'))
    nb_series_to_zero = nb_series - 1
    base_url = $(container).attr('data-source')
    for number in [0..nb_series_to_zero]
      $.getJSON(base_url + "/" + number + ".json", (data) ->
        axis = 0
        axis = 1 if data.type == "area"
        chart.addSeries({
          name: data.name
          data: data.values
          type: data.type
          yAxis: axis
          marker: { enabled: false}
        })
      )
