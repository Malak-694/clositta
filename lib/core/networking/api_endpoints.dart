class ApiEndpoints {
  static const String baseUrl =
      'https://graduationproject-production-f0f3.up.railway.app';

  static const String login = '/api/auth/login';
  static const String signUp = '/api/auth/register';
static const String google= '/api/auth/google';
  static const String profile = "/api/auth/profile";
  static const String delete_profile_image = "/api/auth/profile/image";
  static const String forget_password = "/api/auth/forgot-password";
  static const String verfiy_reset_code = "/api/auth/verify-reset-code";
  static const String reset_password = "/api/auth/reset-password";
  // Tailor
  static const String viewBiddingTailor = '/api/bids/all';
  static const String offers = '/api/offers/{id}';
  static const String acceptOffer = "/api/offers/{offerId}/accept";
  static const String editeOffer = '/api/offers/{offerId}';
  static const String myOrder = "/api/offers/my/accepted";
  static const String updateState = "/api/offers/{offerId}/work-status";
  // Tailor-portfolio
  static const String viewPortfolioTailor = '/api/portfolio/my';
  static const String deletePortfolioTailor = '/api/portfolio/{itemId}';
  static const String updatePortfolioTailor = '/api/portfolio/{itemId}';
  static const String createPortfolioTailor = '/api/portfolio';
  static const String tailorInfo = '/api/portfolio/all' ;
  // Customer
  static const String myBids = '/api/bids';
  static const String createBid = '/api/bids';
  static const String updateBid = "/api/bids/{bidId}";
  static const String bestOffers = '/api/offers/{bidId}/best';
  static const String rateOffer = '/api/offers/{offerId}/rate';
  // Customer-closet
  static const String viewClosetItems = '/api/closet';
  static const String deleteClosetItem = '/api/closet/{itemId}';
  static const String createClosetItems = '/api/closet';
  static const String updateClosetItem = '/api/closet/{itemId}';
  // Seller
  static const String sellerProducts = '/api/products/my/products';
  static const String product = '/api/products/{productId}';
  static const String addProduct = "/api/products";
  // Ecommerce
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
  static const String cancelSubOrder =
      '/api/orders/{orderId}/suborders/{subOrderId}/cancel';
  static const String getOrderById = '/api/orders/{orderId}';
  static const String getMyOrders = '/api/orders/my';
  static const String paymentInitiate = '/api/payments/initiate';
  //seller-orders
  static const String getAllOrdersSeller = '/api/orders/seller';
  static const String updateOrderStatusSeller = '/api/orders/{orderId}/suborders/{suborderId}/status';

  static const String socketUrl = baseUrl;

  // ── Chat ──────────────────────────────────────────
  static const String conversations = '/api/chat/conversations';
  static const String chatHistory   = '/api/chat/{userId}';      // GET /api/chat/:userId
  static const String unreadCount   = '/api/chat/unread';        // GET /api/chat/unread
  // ── Measurements ──────────────────────────────────────────
static const String measurements = '/api/auth/measurements';

}
