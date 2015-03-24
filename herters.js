(function(angular, moment) {
  'use strict';
  
  angular.module('Herters', ['ngResource'])
    .controller('HertersCtrl', ['$scope', 'SalesService', function($scope, SalesService) {
      SalesService.get(function(sales) {
        $scope.sales = sales.prices;
        $scope.updated = moment(sales.updated).fromNow();
      });
    }])
    
  .service('SalesService', ['$resource', function($resource) {
    return $resource('sales.json', {}, {
      get: {
        method: 'GET',
        isArray: false
      }
    });
  }]);
  
})(angular, moment);
