import 'package:chicora/features/customer/biding/ui/widgets/bid_item.dart';
import 'package:chicora/features/customer/biding/ui/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  Widget buildTestApp({required Widget child}) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          ScreenUtil.init(context, designSize: const Size(412, 917));

          return Scaffold(body: child);
        },
      ),
    );
  }

  group('BidItem widget', () {
    testWidgets('shows tailor details and both action buttons', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: BidItem(
            offerId: 'offer-1',
            tailor: 'Tailor Al',
            tailorId: 'tailor-1',
            tailorImage: '',
            email: 'tailor@example.com',
            price: 180,
            num_work: 5,
            duration: 3,
            comment: 'I can finish this quickly',
            showSelectButton: true,
            onAccept: () {},
          ),
        ),
      );

      expect(find.text('Tailor Al'), findsOneWidget);
      expect(find.text('\$180'), findsOneWidget);
      expect(find.text(' 3d'), findsOneWidget);
      expect(find.text('I can finish this quickly'), findsOneWidget);
      expect(find.text('chat'), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('hides Select button when showSelectButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: BidItem(
            offerId: 'offer-2',
            tailor: 'Tailor B',
            tailorId: 'tailor-2',
            tailorImage: '',
            email: 'tailorb@example.com',
            price: 120,
            num_work: 2,
            duration: 5,
            comment: null,
            showSelectButton: false,
          ),
        ),
      );

      expect(find.text('Tailor B'), findsOneWidget);
      expect(find.text('\$120'), findsOneWidget);
      expect(find.text('Select'), findsNothing);
      expect(find.text('chat'), findsOneWidget);
    });

    testWidgets('calls onAccept callback when Select button is tapped', (
      tester,
    ) async {
      var accepted = false;

      await tester.pumpWidget(
        buildTestApp(
          child: BidItem(
            offerId: 'offer-3',
            tailor: 'Tailor C',
            tailorId: 'tailor-3',
            tailorImage: '',
            email: 'tailorc@example.com',
            price: 200,
            num_work: 7,
            duration: 1,
            comment: 'Ready to start',
            showSelectButton: true,
            onAccept: () => accepted = true,
          ),
        ),
      );

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();

      expect(accepted, isTrue);
    });
  });

  group('PostItem widget', () {
    testWidgets('displays title, date and status badge', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          buildTestApp(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 500,
                child: const PostItem(
                  title: 'Alter wedding gown',
                  Image_url: 'https://example.com/image.jpg',
                  date: '2024-06-26',
                  status: 'selected',
                  bidCount: 3,
                ),
              ),
            ),
          ),
        );
      });

      expect(find.text('Alter wedding gown'), findsOneWidget);
      expect(find.text('2024-06-26'), findsOneWidget);
      expect(find.text('selected'), findsOneWidget);
    });
  });
}
