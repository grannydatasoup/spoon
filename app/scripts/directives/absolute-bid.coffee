angular.module('thesoupApp').directive('absoluteBidChart',
  ['$log', 'charts', 'Stat', '_', ($log, charts, Stat, _) ->

    scope: (
      portfolio_id: '=portfolioId'
    )
    link: ($scope, element) ->
      charts.then( (charts) ->

        dt = new charts.DataTable()
        dt.addColumn('number', 'Bid Delta')
        dt.addColumn('number', 'Keywirds Count')

        options = (
          chart: (
            title: 'Cpc Bid value'
          ),
          axes: (
            x: (
              0: (side: 'top')
            )
          ),
          hAxis: (
            title: 'Cpc Bid'
          ),
          vAxis: (
            title: 'Bid count'
          )
        )

        Stat.portfolio_actual($scope.portfolio_id).then(
          (histogram) ->
            element.empty()
            material = new charts.LineChart(element.get()[0]);
            dt.addRows(_.map(histogram, (bin) -> [bin.CpcBid, bin.Count]))
            material.draw(dt, options);
        )
      )
])
