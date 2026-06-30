import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<MeasurementsModel?> showOtherMeasuresBottomSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String? unit = 'cm';
  final weightCtrl = TextEditingController();
  final chestCtrl = TextEditingController();
  final waistCtrl = TextEditingController();
  final hipsCtrl = TextEditingController();
  final shouldersCtrl = TextEditingController();
  final armLengthCtrl = TextEditingController();
  final inseamCtrl = TextEditingController();
  final heightCtrl = TextEditingController();

  Widget numberField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  return showModalBottomSheet<MeasurementsModel>(
    context: context,
    isScrollControlled: true, // lets the sheet grow with keyboard/content
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateSheet) {
          return Padding(
            // pushes content above the keyboard
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Text(
                      'Enter Other Measurements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: unit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'cm', child: Text('cm')),
                        DropdownMenuItem(value: 'in', child: Text('in')),
                      ],
                      onChanged: (val) {
                        setStateSheet(() => unit = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    numberField('Weight', weightCtrl),
                    numberField('Height', heightCtrl),

                    numberField('Chest', chestCtrl),
                    numberField('Waist', waistCtrl),
                    numberField('Hips', hipsCtrl),
                    numberField('Shoulders', shouldersCtrl),
                    numberField('Arm Length', armLengthCtrl),
                    numberField('Inseam', inseamCtrl),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final result = MeasurementsModel(
                                unit: unit,
                                weight: int.tryParse(weightCtrl.text),
                                chest: int.tryParse(chestCtrl.text),
                                waist: int.tryParse(waistCtrl.text),
                                hips: int.tryParse(hipsCtrl.text),
                                shoulders: int.tryParse(shouldersCtrl.text),
                                armLength: int.tryParse(armLengthCtrl.text),
                                inseam: int.tryParse(inseamCtrl.text),
                                height: int.tryParse(heightCtrl.text),
                              );
                              Navigator.pop(context, result);
                            },
                            child: const Text('Yes'),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Discard'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
