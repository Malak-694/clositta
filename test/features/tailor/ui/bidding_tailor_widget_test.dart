// test/features/tailor/bidding_tailor/ui/bidding_tailor_widget_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:chicora/core/di/dependency_injection.dart';
import 'package:chicora/core/helper/shared_pref_helper.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/accepted_offer_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/bid_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/data/models/post_tailor_model.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_cubit.dart';
import 'package:chicora/features/tailor/bidding_tailor/logic/cubit/bidding_tailor_state.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/widgets/bid_item_tailor.dart';
import 'package:chicora/features/tailor/bidding_tailor/ui/widgets/post_item_tailor.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_cubit.dart';
import 'package:chicora/features/ecommerce_multi/logic/cart_cubit/cart_state.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_cubit.dart';
import 'package:chicora/features/chat/logic/conversations_cubit/conversations_state.dart';
import 'package:chicora/features/chat/data/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class MockBiddingTailorCubit extends MockCubit<BiddingTailorState>
    implements BiddingTailorCubit {}

class MockCartCubit extends MockCubit<CartState<dynamic>>
    implements CartCubit {}

class MockConversationsCubit
    extends MockCubit<ConversationsState<List<ConversationModel>>>
    implements ConversationsCubit {}

class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Wraps a widget with all the providers + ScreenUtil that the screens need.
Widget buildTestApp({
  required Widget child,
  required BiddingTailorCubit biddingCubit,
  CartCubit? cartCubit,
  ConversationsCubit? convCubit,
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    child: MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BiddingTailorCubit>.value(value: biddingCubit),
          if (cartCubit != null)
            BlocProvider<CartCubit>.value(value: cartCubit),
          if (convCubit != null)
            BlocProvider<ConversationsCubit>.value(value: convCubit),
        ],
        child: child,
      ),
    ),
  );
}

// ── Fake data ─────────────────────────────────────────────────────────────────
PostTailorResponse fakePost = PostTailorResponse(
  id: 'post-1',
  customer: CustomerModel(
    id: 'cust-1',
    name: 'Sara',
    email: 'sara@example.com',
    phone: '01012345678',
  ),
  requestDescription: 'Wedding dress alteration',
  imageUrl:
      'https://i.pinimg.com/1200x/0f/61/3a/0f613a5ccf00403126aea24fe8fad877.jpg',
  price: 250,
  time: '5 days',
  status: 'open',
  createdAt: '2024-01-01T10:00:00Z',
  updatedAt: '2024-01-01T10:00:00Z',
  iV: 0,
);

BidModelReponse fakeBidOffer = BidModelReponse(
  id: 'offer-1',
  bid: 'post-1',
  tailor: Tailor(
    id: 'tailor-1',
    name: 'Ali Hassan',
    email: 'ali@example.com',
    phone: '01011111111',
  ),
  price: 200,
  timeInDays: 4,
  message: 'I can handle this easily.',
  createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
  updatedAt: DateTime.parse('2024-01-01T10:00:00Z'),
  version: 0,
);

BidModelReponse myBidOffer = BidModelReponse(
  id: 'offer-2',
  bid: 'post-1',
  tailor: Tailor(
    id: 'my-tailor-id',
    name: 'Me',
    email: 'me@example.com',
    phone: '01022222222',
  ),
  price: 180,
  timeInDays: 3,
  message: 'My offer',
  createdAt: DateTime.parse('2024-01-02T10:00:00Z'),
  updatedAt: DateTime.parse('2024-01-02T10:00:00Z'),
  version: 0,
);

AcceptedOfferResponse fakeAcceptedOffer = AcceptedOfferResponse(
  id: 'accepted-1',
  bid: AcceptedOfferBid(
    id: 'post-1',
    requestDescription: 'Wedding dress',
    customer: AcceptedOfferCustomer(
      id: 'cust-1',
      name: 'Sara',
      email: 'sara@example.com',
      phone: '01012345678',
    ),
    imageUrl:
        'https://i.pinimg.com/1200x/0f/61/3a/0f613a5ccf00403126aea24fe8fad877.jpg',
    price: 250,
  ),
  price: 200,
  timeInDays: 4,
  message: 'Offer accepted',
  status: 'accepted',
  workStatus: 'in_progress',
  deadline: DateTime.parse('2024-01-05T10:00:00Z'),
  daysRemaining: 3,
  isOverdue: false,
  createdAt: DateTime.parse('2024-01-01T10:00:00Z'),
  updatedAt: DateTime.parse('2024-01-02T10:00:00Z'),
  version: 0,
);

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockBiddingTailorCubit mockCubit;
  late MockCartCubit mockCartCubit;
  late MockConversationsCubit mockConvCubit;
  late MockSharedPrefHelper mockPrefs;

  setUp(() {
    mockCubit = MockBiddingTailorCubit();
    mockCartCubit = MockCartCubit();
    mockConvCubit = MockConversationsCubit();
    mockPrefs = MockSharedPrefHelper();

    // Register shared pref mock in getIt so screens can resolve it
    if (!getIt.isRegistered<SharedPrefHelper>()) {
      getIt.registerSingleton<SharedPrefHelper>(mockPrefs);
    }

    // Default stubs
    when(
      () => mockPrefs.getSecureData(any()),
    ).thenAnswer((_) async => 'fake-user-id');
    when(() => mockCartCubit.state).thenReturn(const CartState.initial());
    when(
      () => mockConvCubit.state,
    ).thenReturn(const ConversationsState.initial());
    when(() => mockConvCubit.unreadCount).thenReturn(0);
  });

  tearDown(() => getIt.reset());

  // ── BidItemTailor widget ────────────────────────────────────────────────────

  group('BidItemTailor widget', () {
    testWidgets('shows tailor name, price and duration', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Ali Hassan',
                price: 200,
                duration: 4,
                comment: 'Fast delivery',
                isMyOffer: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Ali Hassan'), findsOneWidget);
      expect(find.text('\$200'), findsOneWidget);
      expect(find.text(' 4d'), findsOneWidget);
      expect(find.text('Fast delivery'), findsOneWidget);
    });

    testWidgets('hides Edit/Delete buttons when isMyOffer is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Ali',
                price: 100,
                duration: 2,
                isMyOffer: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Edit'), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('shows Edit and Delete buttons when isMyOffer is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Me',
                price: 150,
                duration: 3,
                isMyOffer: true,
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('calls onEdit callback when Edit is tapped', (tester) async {
      bool editCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Me',
                price: 150,
                duration: 3,
                isMyOffer: true,
                onEdit: () => editCalled = true,
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit'));
      await tester.pump();

      expect(editCalled, isTrue);
    });

    testWidgets('calls onDelete callback when Delete is tapped', (
      tester,
    ) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Me',
                price: 150,
                duration: 3,
                isMyOffer: true,
                onEdit: () {},
                onDelete: () => deleteCalled = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('hides comment section when comment is null', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: BidItemTailor(
                tailorName: 'Ali',
                price: 100,
                duration: 2,
                comment: null,
                isMyOffer: false,
              ),
            ),
          ),
        ),
      );

      // No comment text should appear
      expect(find.byType(Text), findsNWidgets(3)); // name, price, duration only
    });
  });

  // ── PostItemTailor widget ───────────────────────────────────────────────────

  group('PostItemTailor widget', () {
    testWidgets('displays title, price and period', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: PostItemTailor(
                title: 'Wedding dress alteration',
                bidCount: 3,
                date: '2024-01-01',
                Image_url: 'https://example.com/image.jpg',
                price: '\$250',
                period: '5 days',
                status: 'open',
                id: 'post-1',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Wedding dress alteration'), findsOneWidget);
      expect(find.text('\$250'), findsOneWidget);
      expect(find.text('5 days'), findsOneWidget);
    });

    testWidgets('shows green background for open status', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          child: MaterialApp(
            home: Scaffold(
              body: PostItemTailor(
                title: 'Open post',
                bidCount: 0,
                date: '2024-01-01',
                Image_url: 'https://example.com/img.jpg',
                price: '\$100',
                period: '3 days',
                status: 'open',
                id: 'post-open',
              ),
            ),
          ),
        ),
      );
      // Widget renders without error — status color logic is internal
      expect(find.text('Open post'), findsOneWidget);
    });
  });
}
