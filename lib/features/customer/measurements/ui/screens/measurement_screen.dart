import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_model.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_cubit.dart';
import 'package:chicora/features/customer/measurements/logic/cubit/measurements_state.dart';
import 'package:chicora/features/customer/measurements/ui/widgets/measurements_actions.dart';
import 'package:chicora/features/customer/measurements/ui/widgets/measurements_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/measurement_guide_card_widget.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _shouldersController = TextEditingController();
  final _armLengthController = TextEditingController();
  final _inseamController = TextEditingController();
  final _heightController = TextEditingController();

  String _unit = 'cm';
  bool _formPopulated = false;

  @override
  void dispose() {
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _shouldersController.dispose();
    _armLengthController.dispose();
    _inseamController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _populateForm(MeasurementsModel data) {
    _chestController.text = _formatValue(data.chest);
    _waistController.text = _formatValue(data.waist);
    _hipsController.text = _formatValue(data.hips);
    _shouldersController.text = _formatValue(data.shoulders);
    _armLengthController.text = _formatValue(data.armLength);
    _inseamController.text = _formatValue(data.inseam);
    _heightController.text = _formatValue(data.height);
    _unit = data.unit;
    _formPopulated = true;
  }

  String _formatValue(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  void _clearForm() {
    _chestController.clear();
    _waistController.clear();
    _hipsController.clear();
    _shouldersController.clear();
    _armLengthController.clear();
    _inseamController.clear();
    _heightController.clear();
    _unit = 'cm';
    _formPopulated = false;
  }

  MeasurementsRequest _buildRequest() {
    return MeasurementsRequest(
      chest: double.parse(_chestController.text.trim()),
      waist: double.parse(_waistController.text.trim()),
      hips: double.parse(_hipsController.text.trim()),
      shoulders: double.parse(_shouldersController.text.trim()),
      armLength: double.parse(_armLengthController.text.trim()),
      inseam: double.parse(_inseamController.text.trim()),
      height: double.parse(_heightController.text.trim()),
      unit: _unit,
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Measurements'),
        content: const Text(
          'Are you sure you want to delete your body measurements?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.ternary),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<MeasurementsCubit>().deleteMeasurements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeasurementsCubit, MeasurementsState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            if (data is GetMeasurementsResponse && data.measurements != null) {
              if (!_formPopulated) {
                setState(() => _populateForm(data.measurements!));
              }
            } else if (data is SaveMeasurementsResponse) {
              setState(() => _populateForm(data.measurements));
              _showSnackBar(data.message);
            } else if (data is DeleteMeasurementsResponse) {
              setState(_clearForm);
              _showSnackBar(data.message);
            }
          },
          fail: (message) {
            if (message.contains('No measurements found')) {
              setState(_clearForm);
            } else {
              _showSnackBar(message);
            }
          },
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final cubit = context.read<MeasurementsCubit>();
        final hasExisting = cubit.currentMeasurements != null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Body Measurements',
            leading: true,
            showCartIcon: false,
            onCartTap: () {},
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (hasExisting && cubit.currentMeasurements != null)
                  MeasurementsSummaryCard(
                    chest: cubit.currentMeasurements!.chest,
                    waist: cubit.currentMeasurements!.waist,
                    hips: cubit.currentMeasurements!.hips,
                    unit: cubit.currentMeasurements!.unit,
                  ),

                SizedBox(height: 20.h),

                MeasurementGuideCard(), // <-- image here

                SizedBox(height: 24.h),
                MeasurementsForm(
                  formKey: _formKey,
                  chestController: _chestController,
                  waistController: _waistController,
                  hipsController: _hipsController,
                  shouldersController: _shouldersController,
                  armLengthController: _armLengthController,
                  inseamController: _inseamController,
                  heightController: _heightController,
                  unit: _unit,
                  onUnitChanged: (value) => setState(() => _unit = value),
                ),
                SizedBox(height: 32.h),
                MeasurementsActions(
                  hasExistingMeasurements: hasExisting,
                  isLoading: isLoading,
                  onSave: () {
                    if (!_formKey.currentState!.validate()) return;
                    cubit.saveMeasurements(_buildRequest());
                  },
                  onDelete: _confirmDelete,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyle.smallBackground),
        backgroundColor: AppColors.primery,
      ),
    );
  }
}
