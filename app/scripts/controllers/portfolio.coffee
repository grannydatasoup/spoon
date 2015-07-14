angular.module 'thesoupApp'
  .controller 'PortfolioCtrl', ($scope, $log, $resource, PortfolioAccount, User, Config) ->

    emptyPortfolio = () ->
      name: "Default portfolio",
      settings: (
        RPA: 100,
        MaxBid: 10,
        Campaigns: []
      )

    Portfolio = $resource("#{Config.api}/portfolio/:portfolioName", portfolioName: '@name')

    $scope.init() ->
      $scope.portfolio = Portfolio.query()
      User.accounts().then(
        (acc) ->
          $log.debug("Got user accounts")
          $log.debug(acc)
          $scope.accounts = acc
          $scope.accountsError = false
        () ->
          $scope.accountsError = true
      )
      {}

    $scope.addAccount = (portfolio, account) ->
      PortfolioAccount.save(portfolio.name, account)

    $scope.removeAccount = (portfolio, account) ->
      PortfolioAccount.remove(portfolio.name, account)

    $scope.startPortfolioCreation = () ->
      $scope.portfolioUnderConstruction = emptyPortfolio()

    $scope.cancelPortfolioCreation = () ->
      $scope.portfolioUnderConstruction = null

    $scope.savePortfolio = (portfolio) ->
      if portfolio?
        portfolio.$save()
      else
        new Portfolio($scope.portfolioUnderConstruction).$save()


