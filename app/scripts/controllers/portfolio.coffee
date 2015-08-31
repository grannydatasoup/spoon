angular.module 'thesoupApp'
  .controller 'PortfolioCtrl', ($scope, $log, $resource, $q, PortfolioCampaign,
    User, Config, Flash, $filter, ngTableParams) ->

    emptyPortfolio = () ->
      name: "Default portfolio",
      settings: (
        RPA: 100,
        MaxBid: 10,
        Campaigns: []
      ),
      accounts: []

    $scope.accountsError = false
    $scope.statuses = [
      (id:"UNKNOWN", title: "UNKNOWN"),
      (id: "ENABLED", title: "ENABLED"),
      (id: "PAUSED", title: "PAUSED"),
      (id: "REMOVED", title: "REMOVED")
    ]

    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')

    reloadPortfolios = () ->
      $scope.portfolios = Portfolio.query()
      $scope.portfolios.$promise.then(
        () ->
          reloadCampaigns()
        () ->
          Flash.create('danger', 'Was unable to load portfolio, try again later')
      )

    reloadCampaigns = (portfolio) ->
      if portfolio?
        PortfolioCampaign.query(portfolio.name).then(
          (campaigns) ->
            portfolio.campaigns = _.object(
              _.map(campaigns, (c) -> c.id),
              _.map(campaigns, true)
            )
          () ->
            Flash.create('danger', "Was unable to load campaigns linked to portfolio '#{portfolio.name}'")
        )
      else
        $scope.portfolios.$promise.then () ->
          _.each($scope.portfolios, (p) ->
            p.campaigns = null
            reloadCampaigns(p)
          )


    campaings_promise = User.campaigns()

    $scope.tableParams = new ngTableParams({
        filter: {
          status: "ENABLED"
        },
        page: 1,
        count: 100
      }, {
      getData: ($defer, params) ->
        campaings_promise.then(
          (c) ->
            orderedData = $filter('filter')(c, params.filter()) if params.filter()
            orderedData = c unless params.filter();

            $defer.resolve orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())
            params.total(orderedData.length);
          () ->
            $defer.reject()
        )

        $defer.promise
    })

    $scope.accounts = $q.defer()

    $scope.init = () ->
      $scope.portfolios = Portfolio.query()

      campaings_promise.then(
        (c) ->
          $scope.campaigns = _.map(c, (cc) ->
            ccc = cc
            ccc['account_id'] = cc.account.id
            ccc
          )
          accounts = []
          _.each($scope.campaigns, (c) ->
            a = (id: c.account.id, title: c.account.name)
            if _.indexOf(accounts, a) is -1
              accounts.push(a)
          )
          $scope.accounts.resolve accounts

        () ->
          Flash.create('danger', 'Was unable to load campaigns')
      )

      $q.all((campaigns: campaings_promise, portfolios: $scope.portfolios.$promise)).then(
        () ->
          reloadCampaigns()
      )

      $scope.portfolioUnderConstruction = emptyPortfolio()

    $scope.removePortfolio = (portfolio) ->
      portfolio.$remove().then(
        () ->
          reloadPortfolios()
        () ->
          Flash.create('danger', "Was unable to remove portfolio '#{portfolio.name}'")
      )

    $scope.updatePortfolio = (portfolio) ->

      campaignsUpdate = $q.defer()

      if portfolio.campaignsToRemove? and portfolio.campaignsToRemove.length > 0
        PortfolioCampaign.remove(portfolio.name, portfolio.campaignsToRemove).then(
          () ->
            campaignsUpdate.resolve()
          () ->
            campaignsUpdate.reject()
        )
      else
        campaignsUpdate.resolve()

      campaignsUpdate.then(
        () ->
          if portfolio.newName?
            wait = $q.defer()

            updated = new Portfolio(name: portfolio.newName, settings: portfolio.settings)

            PortfolioCampaign.query(portfolio.name).then(
              (campaigns) ->
                portfolio.$remove().then(
                  updated.$save().then(
                    () ->
                      PortfolioCampaign.save(updated.name, campaigns).then(
                        () ->
                          wait.resolve()
                        () ->
                          wait.reject()
                      )
                    () ->
                      wait.reject()
                  )
                  () ->
                    wait.reject()
                )
              () ->
                wait.reject()
            )

            p = wait.promise
          else
            p = portfolio.$save()

          p.then(
            () ->
              reloadPortfolios()
            () ->
              Flash.create('danger', "Was unable to update portfolio '#{portfolio.name}'")
          )
        () ->
          Flash.create('danger', "Was unable to update campaigns for portfolio '#{portfolio.name}'")
      )


    $scope.savePortfolio = () ->
      p = $scope.portfolioUnderConstruction
      new Portfolio(p).$save(() ->
        PortfolioCampaign.save(p.name, p.campaignsToAdd).then(
          () ->
            reloadPortfolios()
            $scope.portfolioUnderConstruction = emptyPortfolio()
          () ->
            Flash.create('danger', "Was unable to create new portfolio")
        )
      )



