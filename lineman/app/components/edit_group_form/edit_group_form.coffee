angular.module('loomioApp').factory 'EditGroupForm', ->
  templateUrl: 'generated/components/edit_group_form/edit_group_form.html'
  controller: ($scope, $rootScope, group, FormService, Records) ->
    $scope.group = group.clone()

    $scope.submit = FormService.submit $scope, $scope.group,
      flashSuccess: 'edit_group_form.messages.success'

    legacyVisibilityMapping =
      public:       'open'
      organization: 'closed'
      members:      'private'

    setDefaultVisibility = (group) ->
      return group.visibleTo if _.contains ['open', 'closed', 'private'], group.visibleTo
      if mappedLegacyValue = legacyVisibilityMapping[group.visibleTo]
        mappedLegacyValue
      else if $scope.group.isSubgroup()
        setDefaultVisibility(group.parent())
      else
        'open'

    $scope.group.visibleTo = setDefaultVisibility($scope.group)

    $scope.expandForm = ->
      $scope.expanded = true

    return
