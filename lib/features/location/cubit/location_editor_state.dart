abstract class LocationEditorState {}

class LocationEditorInitial extends LocationEditorState {}

class LocationEditorLoading extends LocationEditorState {}

class LocationEditorSuccess extends LocationEditorState {}

class LocationEditorError extends LocationEditorState {
  final String message;

  LocationEditorError(this.message);
}
