import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/accepted_offer_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/bid_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/join_bidding_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/repo/bidding_tailor_repo.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBiddingTailorRepo extends Mock implements BiddingTailorRepo {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

void main() {
  late MockBiddingTailorRepo mockRepo;
  late MockSharedPrefHelper mockPrefs;
  late BiddingTailorCubit cubit;

  setUpAll(() {
    registerFallbackValue(JoinBiddingRequest(
      price: 150,
      timeInDays: 4,
      message: 'Sure, I can sew this!',
    ));
  });

  setUp(() {
    mockRepo = MockBiddingTailorRepo();
    mockPrefs = MockSharedPrefHelper();
    
    // Register mock dependencies
    getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    
    cubit = BiddingTailorCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  final fakePost = PostTailorResponse(
    id: "post-123",
    customer: CustomerModel(id: "customer-123", name: "Customer Bob"),
    requestDescription: "Need a wedding dress tailor",
    imageUrl: "https://via.placeholder.com/150",
    price: 300,
    time: "10 days",
    status: "open",
  );

  final fakeJoinResponse = JoinBiddingResponse(
    message: "Joined successfully",
  );

  group('getBiddingTailors', () {
    blocTest<BiddingTailorCubit, BiddingTailorState>(
      'emits [Loading, Success] when token is found and API succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.getBiddingTailors(any()))
            .thenAnswer((_) async => [fakePost]);
        return cubit;
      },
      act: (cubit) => cubit.getBiddingTailors(),
      expect: () => [
        const BiddingTailorState.loading(),
        BiddingTailorState<dynamic>.success([fakePost]),
      ],
    );

    blocTest<BiddingTailorCubit, BiddingTailorState>(
      'emits [Loading, Fail] when token is null',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.getBiddingTailors(),
      expect: () => [
        const BiddingTailorState.loading(),
        const BiddingTailorState.fail('Authentication token not found'),
      ],
    );
  });

  group('joinBidding', () {
    blocTest<BiddingTailorCubit, BiddingTailorState>(
      'emits [Loading, Success] when joining bidding succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.joinBidding(any(), any(), any()))
            .thenAnswer((_) async => fakeJoinResponse);
        return cubit;
      },
      act: (cubit) => cubit.joinBidding(
        postId: 'post-123',
        request: JoinBiddingRequest(
          price: 250,
          timeInDays: 5,
          message: "I can do this design perfectly",
        ),
      ),
      expect: () => [
        const BiddingTailorState.loading(),
        BiddingTailorState<dynamic>.success(fakeJoinResponse),
      ],
    );
  });

  group('deleteOffer', () {
    blocTest<BiddingTailorCubit, BiddingTailorState>(
      'emits [Loading, Success, Loading, Success] when deleting offer succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.deleteOffer(
              token: any(named: 'token'),
              offerId: any(named: 'offerId'),
            )).thenAnswer((_) async => Future.value());
        when(() => mockRepo.getOffers(any(), any()))
            .thenAnswer((_) async => <BidModelReponse>[]);
        return cubit;
      },
      act: (cubit) => cubit.deleteOffer(offerId: 'offer-123', postId: 'post-123'),
      expect: () => [
        const BiddingTailorState.loading(),
        const BiddingTailorState<dynamic>.success("Offer deleted successfully"),
        const BiddingTailorState.loading(),
        const BiddingTailorState<dynamic>.success(<BidModelReponse>[]),
      ],
    );
  });

  group('getMyAcceptedOffers', () {
    blocTest<BiddingTailorCubit, BiddingTailorState>(
      'emits [Loading, Success] when fetching accepted offers succeeds',
      build: () {
        when(() => mockPrefs.getSecureData(any()))
            .thenAnswer((_) async => 'fake-token-123');
        when(() => mockRepo.getMyAcceptedOffers(any()))
            .thenAnswer((_) async => <AcceptedOfferResponse>[]);
        return cubit;
      },
      act: (cubit) => cubit.getMyAcceptedOffers(),
      expect: () => [
        const BiddingTailorState.loading(),
        const BiddingTailorState<dynamic>.success(<AcceptedOfferResponse>[]),
      ],
    );
  });
}
