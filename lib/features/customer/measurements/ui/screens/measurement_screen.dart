import 'package:chicora/core/constants/colors.dart';
import 'package:chicora/core/constants/style.dart';
import 'package:chicora/core/widgets/custom_app_bar.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_request_model.dart';
import 'package:chicora/features/customer/measurements/data/model/measurements_response_model.dart';
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

  String _unit = 'CM';
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
    _chestController.text = data.chest?.toString() ?? '';
    _waistController.text = data.waist?.toString() ?? '';
    _hipsController.text = data.hips?.toString() ?? '';
    _shouldersController.text = data.shoulders?.toString() ?? '';
    _armLengthController.text = data.armLength?.toString() ?? '';
    _inseamController.text = data.inseam?.toString() ?? '';
    _heightController.text = data.height?.toString() ?? '';

    _unit = data.unit ?? 'CM';

    _formPopulated = true;
  }

  String _formatValue(int value) {
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
    _unit = 'CM';
    _formPopulated = false;
  }

  MeasurementsModel _buildRequest() {
    return MeasurementsModel(
      chest: int.parse(_chestController.text.trim()),
      waist: int.parse(_waistController.text.trim()),
      hips: int.parse(_hipsController.text.trim()),
      shoulders: int.parse(_shouldersController.text.trim()),
      armLength: int.parse(_armLengthController.text.trim()),
      inseam: int.parse(_inseamController.text.trim()),
      height: int.parse(_heightController.text.trim()),
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
            if (data is MeasurementsResponseModel &&
                data.measurements != null) {
              if (!_formPopulated) {
                setState(() => _populateForm(data.measurements!));
              }
            }
          },
          fail: (message) => _showSnackBar(message),
        );
      },
      builder: (context, state) {
        debugPrint("MeasurementScreen rebuilt");
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final cubit = context.read<MeasurementsCubit>();
        final hasExisting = cubit.currentMeasurements?.hasMeasurements ?? false;

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
                if (hasExisting)
                  MeasurementsSummaryCard(
                    chest: cubit.currentMeasurements!.chest ?? 0,
                    waist: cubit.currentMeasurements!.waist ?? 0,
                    hips: cubit.currentMeasurements!.hips ?? 0,
                    unit: cubit.currentMeasurements!.unit!,
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
                    cubit.updateMeasurements(_buildRequest());
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
