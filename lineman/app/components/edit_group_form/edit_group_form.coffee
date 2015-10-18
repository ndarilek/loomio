angular.module('loomioApp').factory 'EditGroupForm', ->
  templateUrl: 'generated/components/edit_group_form/edit_group_form.html'
  controller: ($scope, $rootScope, group, FormService, Records) ->
    $scope.group = group.clone()

    $scope.submit = FormService.submit $scope, $scope.group,
      flashSuccess: 'edit_group_form.messages.success'

    $scope.expandForm = ->
      $scope.expanded = true

    return
