angular.module 'thesoupApp'
  .controller 'PortfolioCtrl', ($scope, $log, $resource, $q, PortfolioCampaign,
    User, Config, Flash, $filter, ngTableParams) ->

    emptyPortfolio = () ->
      name: "Default portfolio",
      settings: (
        RPA: 100,
        MaxBid: 10
      ),
      campaigns: {},
      tableParams: tableParams(this)


    $scope.accountsError = false
    $scope.statuses = [
      (id:"UNKNOWN", title: "UNKNOWN"),
      (id: "ENABLED", title: "ENABLED"),
      (id: "PAUSED", title: "PAUSED"),
      (id: "REMOVED", title: "REMOVED")
    ]

    $scope.managed_statuses = [
      (id: true, title: "Manged"),
      (id: false, title: "Not manged"),
      (id: null, title: ' - ')
    ]

    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')

    reloadPortfolios = () ->
      _portfolios = Portfolio.query()
      _portfolios.$promise.then(
        () ->
          _.each(_portfolios, (p) -> p.tableParams = tableParams(p))
          $scope.portfolios = _portfolios
          reloadCampaigns()
        () ->
          Flash.create('danger', 'Was unable to load portfolio, try again later')
      )

    campaigns_diff = (portfolio) ->
      new_campaigns = _.map(_.filter(_.pairs(portfolio.campaigns), (c) -> c[1] is true), (c) -> c[0])
      old_campaigns = portfolio?.original_campaigns ? []

      (add: _.difference(new_campaigns, old_campaigns), remove: _.difference(old_campaigns, new_campaigns))



    reloadCampaigns = (portfolio) ->
      if portfolio?
        PortfolioCampaign.query(portfolio.name).then(
          (campaigns) ->
            portfolio.campaigns = _.object(
              _.map(campaigns, (c) -> c.campaignId),
              _.map(campaigns, () -> true)
            )
            portfolio.original_campaigns = _.map(campaigns, (c) -> c.campaignId)
          () ->
            Flash.create('danger', "Was unable to load campaigns linked to portfolio '#{portfolio.name}'")
        )
      else
        $scope.portfolios.$promise.then () ->
          _.each($scope.portfolios, (p) ->
            p.campaigns = null
            reloadCampaigns(p)
          )


    accounts_promise = User.accounts()

    campaings_promise = User.campaigns()

    tableParams = (portfolio) ->
      new ngTableParams({
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

              if portfolio?.campaigns?
                _.each(orderedData, (campaign) ->
                  campaign.managed = portfolio.campaigns[campaign.id]
                )
              else
                _.each(orderedData, (campaign) ->
                  campaign.managed = false
                )

              $defer.resolve orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count())
              params.total(orderedData.length);
            () ->
              $defer.reject()
          )

          $defer.promise
      })

    _accounts = $q.defer()

    $scope.accounts = () ->
      a = $q.defer()
      _accounts.promise.then(
        (ac) ->
          a.resolve angular.copy(ac)
        () ->
          a.reject()
      )

      a

    $scope.init = () ->

      campaings_promise.then(
        (c) ->
          $scope.campaigns = _.map(c, (cc) ->
            ccc = cc
            ccc['account_id'] = cc.account.id
            ccc
          )
          accounts = []
          account_ids = []
          _.each($scope.campaigns, (c) ->
            a = (id: c.account.id, title: c.account.name)
            if _.indexOf(account_ids, a.id) is -1
              accounts.push(a)
              account_ids.push(a.id)
          )
          _accounts.resolve accounts

          reloadPortfolios()

        () ->
          Flash.create('danger', 'Was unable to load campaigns')
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

      diff = campaigns_diff(portfolio)
      $log.debug("Diff is")
      $log.debug(diff)

      campaignsToRemove = diff.remove
      campaignsToAdd = diff.add

      remove = $q.defer()
      add = $q.defer()
      campaignsUpdate = $q.all([add, remove])

      if campaignsToRemove? and campaignsToRemove.length > 0

        PortfolioCampaign.remove(portfolio.name, campaignsToRemove).then(
          () ->
            remove.resolve()
          () ->
            remove.reject()
        )
      else
        remove.resolve()

      if campaignsToAdd? and campaignsToAdd.length > 0

        PortfolioCampaign.save(portfolio.name, campaignsToAdd).then(
          () ->
            add.resolve()
          () ->
            add.reject()
        )
      else
        add.resolve()


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
      campaignsToAdd = campaigns_diff(p).add
      new Portfolio(p).$save(() ->
        PortfolioCampaign.save(p.name, campaignsToAdd).then(
          () ->
            reloadPortfolios()
            $scope.portfolioUnderConstruction = emptyPortfolio()
          () ->
            Flash.create('danger', "Was unable to create new portfolio")
        )
      )



