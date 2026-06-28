import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/customer/biding/data/models/bid_customer_model.dart';
import 'package:chicora/features/customer/biding/data/models/offer_model.dart';
import 'package:chicora/features/customer/biding/data/models/send_bidding_model.dart';
import 'package:chicora/features/customer/biding/data/repo/bid_repo.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_cubit.dart';
import 'package:chicora/features/customer/biding/logic/cubit/custom_bidding_cubit/customer_bidding_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBiddingCustomerRepo extends Mock implements BiddingCustomerRepo {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  late MockBiddingCustomerRepo mockRepo;
  late MockSharedPrefHelper mockPrefs;
  late CustomerBiddingCubit cubit;

  setUpAll(() {
    registerFallbackValue(SendBiddingModel(
      description: 'Test description',
      imageUrl: 'test.jpg',
      price: 100,
      time: '3 days',
    ));
  });

  setUp(() {
    mockRepo = MockBiddingCustomerRepo();
    mockPrefs = MockSharedPrefHelper();
    
    // Register mock dependencies
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    
    cubit = CustomerBiddingCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  final fakeBid = BidResponse(
    id: "bid-123",
    customerId: "customer-123",
    requestDescription: "Test Bid",
    imageUrl: "https://image.url",
    price: 150.0,
    time: "2 days",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    version: 0,
  );

  final fakeOffer = OfferResponse(
    id: "offer-123",
    bid: BidNested(
      id: "bid-123",
      requestDescription: "Test Bid",
      status: "closed",
    ),
    tailor: Tailor(id: "tailor-123", name: "Tailor Al"),
    price: 130,
    timeInDays: 3,
    message: "I can do this!",
    status: "pending",
  );
  group('getMyBids', () {
    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Success] when token is found and API succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.getMyBids(any()))
            .thenAnswer((_) async => [fakeBid]);
        return cubit;
      },
      act: (cubit) => cubit.getMyBids(),
      expect: () => [
        const CustomerBiddingState.loading(),
        CustomerBiddingState<dynamic>.success([fakeBid]),
      ],
    );

    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.getMyBids(),
      expect: () => [
        const CustomerBiddingState.loading(),
        const CustomerBiddingState.fail('Authentication token not found'),
      ],
    );
  });

  group('createBid', () {
    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Success] when bid is created successfully',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.createBidWithFile(
              token: any(named: 'token'),
              description: any(named: 'description'),
              imagePath: any(named: 'imagePath'),
              price: any(named: 'price'),
              time: any(named: 'time'),
            )).thenAnswer((_) async => fakeBid);
        return cubit;
      },
      act: (cubit) => cubit.createBid(
        request: SendBiddingModel(
          description: "New Bid",
          imageUrl: "path/to/image.png",
          price: 200.0,
          time: "3 days",
        ),
      ),
      expect: () => [
        const CustomerBiddingState.loading(),
        CustomerBiddingState<dynamic>.success(fakeBid),
      ],
    );

    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Fail] when request image is empty',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        return cubit;
      },
      act: (cubit) => cubit.createBid(
        request: SendBiddingModel(
          description: "New Bid",
          imageUrl: "",
          price: 200.0,
          time: "3 days",
        ),
      ),
      expect: () => [
        const CustomerBiddingState.loading(),
        const CustomerBiddingState.fail('Please select an image'),
      ],
    );
  });

  group('getOffers', () {
    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Success] when loading offers succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.getOffers(any(), any()))
            .thenAnswer((_) async => [fakeOffer]);
        return cubit;
      },
      act: (cubit) => cubit.getOffers('bid-123'),
      expect: () => [
        const CustomerBiddingState.loading(),
        CustomerBiddingState<dynamic>.success([fakeOffer]),
      ],
    );
  });

  group('acceptOffer', () {
    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Success("Offer accepted successfully"), Loading, Success] when accepting offer succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.acceptOffer(any(), any()))
            .thenAnswer((_) async => Future.value());
        when(() => mockRepo.getBestOffers(any(), any()))
            .thenAnswer((_) async => [fakeOffer]);
        return cubit;
      },
      act: (cubit) => cubit.acceptOffer('offer-123', 'bid-123'),
      expect: () => [
        const CustomerBiddingState.loading(),
        const CustomerBiddingState<dynamic>.success("Offer accepted successfully"),
        const CustomerBiddingState.loading(),
        CustomerBiddingState<dynamic>.success([fakeOffer]),
      ],
    );
  });

  group('deleteBid', () {
    blocTest<CustomerBiddingCubit, CustomerBiddingState>(
      'emits [Loading, Success] when bid is deleted successfully',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.deleteBid(
              token: any(named: 'token'),
              bidId: any(named: 'bidId'),
            )).thenAnswer((_) async => Future.value());
        return cubit;
      },
      act: (cubit) => cubit.deleteBid(bidId: 'bid-123'),
      expect: () => [
        const CustomerBiddingState.loading(),
        const CustomerBiddingState<dynamic>.success("Bid deleted successfully"),
      ],
    );
  });
}
