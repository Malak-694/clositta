class ApiEndpoints {
  static const String baseUrl =
      'https://graduationproject-production-b435.up.railway.app';
  static const String login = '/api/auth/login';
  static const String signUp = '/api/auth/register';

  static const String profile = "/api/auth/profile";
  static const String delete_profile_image = "/api/auth/profile/image";
  //Tailor
  static const String viewBiddingTailor = '/api/bids/all';
  static const String offers = '/api/offers/{id}';
  static const String acceptOffer = "/api/offers/{offerId}/accept";
  static const String editeOffer = '/api/offers/{offerId}';
  //Tailor-portfolio
  static const String viewPortfolioTailor = '/api/portfolio/my';
  static const String deletePortfolioTailor = '/api/portfolio/{itemId}';
  static const String updatePortfolioTailor = '/api/portfolio/{itemId}';
  static const String createPortfolioTailor = '/api/portfolio';
  //customer
  static const String myBids = '/api/bids';
  static const String createBid = '/api/bids';
  static const String updateBid = "/api/bids/{bidId}";
  static const String bestOffers = '/api/offers/{bidId}/best';
  //customer-closet
  static const String viewClosetItems = '/api/closet';
  static const String deleteClosetItem = '/api/closet/{itemId}';
  static const String createClosetItems = '/api/closet';
  static const String updateClosetItem = '/api/closet/{itemId}';
  //seller
  static const String sellerProducts = '/api/products/my/products';
  static const String product = '/api/products/{productId}';
  static const String addProduct = "/api/products";
  //ecommerce
  static const String products = '/api/products/all';
  static const String ratePoduct = '/api/products/{productId}/rate';
  //ecommerce-cart
  static const String cart = '/api/cart';
  static const String updateCartItems = '/api/cart/item/{productId}';
  //seller-analysis
  static const String sellerAnalysis = '/api/analytics/seller';
  //ecommerce-checkout
  static const String placeOrder = '/api/orders';
  static const String cancelOrder = '/api/orders/{orderId}/cancel';
  static const String getOrderById = '/api/orders/{orderId}';
  static const String getMyOrders = '/api/orders/my';
  static const String getAllOrdersSeller = '/api/orders/seller';
  static const String updateOrderStatusSeller = '/api/orders/{orderId}/status';
}
