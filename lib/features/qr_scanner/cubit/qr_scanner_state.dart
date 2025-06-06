abstract class QRScannerState {}

class QRInitial extends QRScannerState {}

class QRLoading extends QRScannerState {
  final String data;
  QRLoading(this.data);
}

class QRSuccess extends QRScannerState {
  final String data;
  QRSuccess(this.data);
}

class QRError extends QRScannerState {
  final String message;
  QRError(this.message);
}
