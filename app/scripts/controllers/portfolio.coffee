angular.module 'thesoupApp'
  .controller 'PortfolioCtrl', ($scope, $log, $resource, $q, PortfolioAccount, User, Config) ->

    emptyPortfolio = () ->
      name: "Default portfolio",
      settings: (
        RPA: 100,
        MaxBid: 10,
        Campaigns: []
      ),
      accounts: []

    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')

    reloadAccounts = (portfolio) ->
      PortfolioAccount.query(portfolio.name).then(
        (customerIds) ->
          portfolio.accounts = _customerIds
      )

    notifyOnError = (message) ->
      $log.warn(message)

    $scope.init = () ->
      $scope.portfolios = Portfolio.query()

      User.campaigns().then(
        (c) ->
          $scope.campaigns = c
      )

      User.accounts().then(
        (acc) ->
          $log.debug("Got user accounts")
          $log.debug(acc.entries)
          $scope.accounts = acc.entries
          $scope.accountsError = false
          $scope.portfolios.$promise.then () ->
            _.each($scope.portfolios, (p) ->
              p.accounts = null
              reloadAccounts(p)
            )
        () ->
          $scope.accountsError = true
      )
      $scope.portfolioUnderConstruction = emptyPortfolio()

    $scope.addAccount = (portfolio) ->
      PortfolioAccount.save(portfolio.name, portfolio.accountToAdd).then(
        () ->
          reloadAccounts(portfolio)
        () ->
          notifyOnError('Was unable to add portfolio account')
      )

    $scope.stageAccount = () ->
      $log.debug("Account staged to be link to new portfolio")
      $log.debug($scope.portfolioUnderConstruction.accountToAdd)
      $scope.portfolioUnderConstruction.accounts.push($scope.portfolioUnderConstruction.accountToAdd)

    $scope.unstageAccount = (account) ->
      $scope.portfolioUnderConstruction.accounts = _.without(
        $scope.portfolioUnderConstruction.accounts,
        account
      )

    $scope.removeAccount = (portfolio, account) ->
      PortfolioAccount.remove(portfolio.name, account)

    $scope.stageCampaignRemoval = (portfolio, campaign) ->
      portfolio.campaigns = _.without(portfolio.campaigns, campaign)

    $scope.stageCampaign = (portfolio) ->
      if portfolio.capmaignToAdd?
        portfolio.campaigns.push(portfolio.capmaignToAdd)
      portfolio.capmaignToAdd = null


    $scope.savePortfolio = () ->
      new Portfolio($scope.portfolioUnderConstruction).$save(() ->
        $q.all(
          _.map(
            _.each(
              $scope.portfolioUnderConstruction.accounts,
              (a) ->
                PortfolioAccount.save($scope.portfolioUnderConstruction.name, a)
            )
          )
        ).then () ->
          $scope.portfolios.push($scope.portfolioUnderConstruction)
          $scope.portfolioUnderConstruction = emptyPortfolio()
      )



