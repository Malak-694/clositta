class ApiEndpoints {
  static const String baseUrl =
      'https://graduationproject-production-38b3.up.railway.app';
  static const String login = '/api/auth/login';
  static const String signUp = '/api/auth/register';
  //Tailor
  static const String viewBiddingTailor = '/api/bids/all';
  static const String offers = '/api/offers/{id}';
  //customer
  static const String myBids = '/api/bids';
  static const String createBid = '/api/bids';
  static const String bestOffers = '/api/offers/{bidId}/best';
  //customer-closet
  static const String viewClosetItems = '/api/closet';
  static const String deleteClosetItem = '/api/closet/{itemId}';
  static const String createClosetItems = '/api/closet';
  static const String updateClosetItem = '/api/closet/{itemId}';
  //seller
  static const String sellerProducts = '/api/products/my/products';
  static const String product = '/api/products/{productId}';
  //ecommerce
  static const String products = '/api/products/all';
  static const String ratePoduct = '/api/products/{productId}/rate';
}
