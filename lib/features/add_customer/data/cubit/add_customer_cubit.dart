import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/services/cloudinary_services.dart';
import 'package:smart_installment_management/core/utils/helper/payment_status_helper.dart';
import 'package:smart_installment_management/features/add_customer/data/cubit/add_customer_state.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/installment_model.dart';

class AddCustomerCubit extends Cubit<AddCustomerState> {
  AddCustomerCubit() : super(AddCustomerInitial());

  double calculateDebt(double sellingPrice, double downPayment) {
    return (sellingPrice - downPayment).clamp(0.0, double.infinity).toDouble();
  }

  int calculateInstallmentsCount({
    required double debt,
    required double installmentAmount,
  }) {
    if (debt <= 0 || installmentAmount <= 0) {
      return 0;
    }
    return (debt / installmentAmount).ceil();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  DateTime _addMonthsClamped(DateTime date, int months) {
    final firstDay = DateTime(date.year, date.month + months, 1);
    final lastDay = DateTime(firstDay.year, firstDay.month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;

    return DateTime(firstDay.year, firstDay.month, day);
  }

  List<InstallmentModel> _createSchedule({
    required double debt,
    required double installmentAmount,
    required String firstDate,
    required String installmentType,
  }) {
    final schedule = <InstallmentModel>[];
    final startDate = DateTime.tryParse(firstDate);

    if (startDate == null || debt <= 0 || installmentAmount <= 0) {
      return schedule;
    }

    final count = calculateInstallmentsCount(
      debt: debt,
      installmentAmount: installmentAmount,
    );

    double remainingDebt = debt;

    for (int i = 0; i < count; i++) {
      if (remainingDebt <= 0) break;
      final amount = remainingDebt < installmentAmount
          ? remainingDebt
          : installmentAmount;

      DateTime dueDate;

      if (installmentType == 'Weekly') {
        dueDate = startDate.add(Duration(days: 7 * i));
      } else if (installmentType == 'Yearly') {
        dueDate = _addMonthsClamped(startDate, 12 * i);
      } else {
        dueDate = _addMonthsClamped(startDate, i);
      }

      schedule.add(
        InstallmentModel(
          installmentNumber: i + 1,
          dueDate: _formatDate(dueDate),
          amount: double.parse(amount.toStringAsFixed(2)),
          paidAmount: 0,
          isPaid: false,
          status: PaymentStatusHelper.statusForDate(_formatDate(dueDate)),
        ),
      );

      remainingDebt = double.parse((remainingDebt - amount).toStringAsFixed(2));
    }

    return schedule;
  }


  Future<void> addCustomer({
    required CustomerModel customer,
    File? image,
  }) async {
    emit(AddCustomerLoading());

    try {
      if (customer.customerName.trim().isEmpty) {
        throw Exception('Please enter the customer name.');
      }

      if (customer.sellingPrice <= 0) {
        throw Exception('Selling price must be greater than zero.');
      }

      if (customer.purchasePrice < 0 || customer.downPayment < 0) {
        throw Exception('Prices cannot be negative.');
      }

      if (customer.downPayment > customer.sellingPrice) {
        throw Exception('Down payment cannot exceed selling price.');
      }

      final bool isEditing = customer.id.isNotEmpty;

      final debt = calculateDebt(
        customer.sellingPrice,
        customer.downPayment,
      );

      if (debt > 0 && customer.installmentAmount <= 0) {
        throw Exception('Please enter a valid installment amount.');
      }

      if (debt > 0 &&
          DateTime.tryParse(customer.firstInstallmentDate) == null) {
        throw Exception('Please select a valid first installment date.');
      }

      String imageUrl = customer.imageUrl;

      if (image != null) {
        imageUrl = await CloudinaryServices.uploadImage(image);
      }

      // When editing, preserve the existing installment schedule
      // and all previously recorded payments.
      final schedule = isEditing
          ? customer.schedule
          : debt > 0
          ? _createSchedule(
        debt: debt,
        installmentAmount: customer.installmentAmount,
        firstDate: customer.firstInstallmentDate,
        installmentType: customer.installmentType,
      )
          : <InstallmentModel>[];

      if (!isEditing) {
        final expectedCount = calculateInstallmentsCount(
          debt: debt,
          installmentAmount: customer.installmentAmount,
        );

        if (schedule.length != expectedCount) {
          throw Exception('Could not create the installment schedule.');
        }
      }

      final preparedCustomer = PaymentStatusHelper.updateCustomer(
        customer.copyWith(
          imageUrl: imageUrl,
          debtAmount: debt,
          installmentsCount: schedule.length,
          schedule: schedule,
          // Never reset previous payments while editing.
          paidValue: isEditing ? customer.paidValue : 0,
          nextDueDate: schedule.isNotEmpty
              ? schedule.firstWhere(
                (item) => !item.isPaid,
            orElse: () => schedule.last,
          ).dueDate
              : '',
        ),
      );

      final customerId = await TaqseetFirestoreServices.saveRecord(
        type: 'customer',
        documentId: isEditing ? customer.id : null,
        data: preparedCustomer.toMap(),
      );

      emit(
        AddCustomerSuccess(
          preparedCustomer.copyWith(id: customerId),
        ),
      );
    } catch (error, stackTrace) {
      print('Save customer error: $error');
      print(stackTrace);

      final message = error.toString().startsWith('Exception: ')
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Could not save customer. Please check your connection and try again.';

      emit(AddCustomerFailure(message));
    }
  }

}
