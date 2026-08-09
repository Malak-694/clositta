class PlaceOrderSuccess {
  const PlaceOrderSuccess({
    this.message,
    this.orderId,
    this.paymentIframeUrl,
  });

  final String? message;
  final String? orderId;
  final String? paymentIframeUrl;
}
