angular.module('loomioApp').factory 'ChangeThreadVolumeForm', ->
  templateUrl: 'generated/components/change_thread_volume_form/change_thread_volume_form.html'
  controller: ($scope, thread, FormService, AppConfig) ->
    $scope.thread = thread.clone()
    $scope.volumeLevels = if AppConfig.isInSandstorm?
      ["quiet", "mute"]
    else
      ["loud", "normal", "quiet", "mute"]

    $scope.submit = FormService.submit $scope, $scope.thread,
      submitFn: $scope.thread.changeVolume
      flashSuccess: -> "thread_volume_form.messages.#{$scope.thread.discussionReaderVolume}"
      flashOptions:
        name: $scope.thread.title

    return
