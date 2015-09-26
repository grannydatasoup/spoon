angular.module('thesoupApp').directive('absoluteBidDiffChart',
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
            title: 'Actual bids difference',
            subtitle: 'Today - Yesterday'
          ),
          axes: (
            x: (
              0: (side: 'top')
            )
          ),
          hAxis: (
            title: 'Bid change'
          ),
          vAxis: (
            title: 'Bid count'
          )
        )

        Stat.portfolio_actual_diff($scope.portfolio_id).then(
          (histogram) ->
            element.empty()
            material = new charts.ColumnChart(element.get()[0]);
            dt.addRows(_.map(histogram, (bin) -> [bin.BidChange, bin.Count]))
            material.draw(dt, options);
        )
      )
])
