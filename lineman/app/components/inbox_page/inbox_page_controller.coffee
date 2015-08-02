angular.module('loomioApp').controller 'InboxPageController', ($scope, $rootScope, Records, CurrentUser, LoadingService, ThreadQueryService) ->
  $rootScope.$broadcast('currentComponent', {page: 'inboxPage'})
  $rootScope.$broadcast('setTitle', 'Inbox')
  $rootScope.$broadcast('analyticsClearGroup')

  @threadLimit = 5
  @views =
    groups: {}

  @loading = -> !(CurrentUser.inboxLoaded and CurrentUser.membershipsLoaded)

  @groups = ->
    CurrentUser.parentGroups()

  @init = =>
    return if @loading()
    _.each @groups(), (group) =>
      @views.groups[group.key] = ThreadQueryService.groupQuery(group)
    @baseQuery = ThreadQueryService.filterQuery('show_unread', queryType: 'inbox')
  $scope.$on 'currentUserMembershipsLoaded', @init
  $scope.$on 'currentUserInboxLoaded', @init
  @init()

  @moreForThisGroup = (group) ->
    @views.groups[group.key].length() > @threadLimit

  return
