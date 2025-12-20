class ApiEndpoints {
  static const String baseUrl = 'https://graduationproject-p.up.railway.app';
  static const String login = '/api/auth/login';
  static const String signUp = '/api/auth/register';
  //Tailor 
  static const String viewBiddingTailor = '/api/bids/all';
  static const String offers = '/api/offers/{id}';
  //customer
  static const String myBids = '/api/bids';
  static const String createBid = '/api/bids';
  static const String bestOffers = '/api/offers/{bidId}/best';
}
