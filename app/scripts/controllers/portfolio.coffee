angular.module 'thesoupApp'
  .controller 'PortfolioCtrl', ($scope, $log, $resource, PortfolioAccount, User, Config) ->

    emptyPortfolio = () ->
      name: "Default portfolio",
      settings: (
        RPA: 100,
        MaxBid: 10,
        Campaigns: []
      ),
      accounts: []

    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')

    reloadAccounts(portfolio) ->
      PortfolioAccount.query(portfolio.name).then(
        (a) -> portfolio.accounts = a
      )

    notifyOnError = (message) ->
      $log.warn(message)

    $scope.init() ->
      $scope.portfolios = Portfolio.query()

      $scope.portfolios.$promise.then () ->
        _.each($scope.portfolios, (p) ->
          p.accounts = null
          reloadAccounts(p)
        )


      User.accounts().then(
        (acc) ->
          $log.debug("Got user accounts")
          $log.debug(acc)
          $scope.accounts = acc
          $scope.accountsError = false
        () ->
          $scope.accountsError = true
      )
      $scope.portfolioUnderConstruction = emptyPortfolio()

    $scope.addAccount = (portfolio) ->
      PortfolioAccount.save(portfolio.name, portfolio.accountToAdd).then(
        () ->
          reloadAccounts()
        () ->
          notifyOnError('Was unable to add portfolio account')
      )

    $scope.stageAccount = () ->
      $scope.portfolioUnderConstruction.accounts.push($scope.portfolioUnderConstruction.accountToAdd)

    $scope.unstageAccount = (account) ->
      $scope.portfolioUnderConstruction.accounts = _.without(
        $scope.portfolioUnderConstruction.accounts,
        account
      )

    $scope.removeAccount = (portfolio, account) ->
      PortfolioAccount.remove(portfolio.name, account)

    $scope.savePortfolio = () ->
      new Portfolio($scope.portfolioUnderConstruction).$save(() ->
        $scope.portfolios.push($scope.portfolioUnderConstruction)
        $scope.portfolioUnderConstruction = emptyPortfolio()
      )



