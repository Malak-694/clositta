class PlaceOrderSuccess {
  const PlaceOrderSuccess({
    this.message,
    this.orderId,
    this.paymentIframeUrl,
  });

  final String? message;
  final String? orderId;

  /// When non-null, open in browser / external WebView (Paymob iframe URL).
  final String? paymentIframeUrl;
}
