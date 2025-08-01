// screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/app_provider.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTransactionScreen extends StatefulWidget {
  final Customer customer;

  const AddTransactionScreen({
    super.key,
    required this.customer,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isDebt = true;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final amountChanged = _isDebt ? amount : -amount;
      final newBalance = widget.customer.currentTotalDebt + amountChanged;

      final transaction = DebtTransaction(
        customerId: widget.customer.id!,
        amountChanged: amountChanged,
        newBalanceAfterTransaction: newBalance,
        transactionNote:
            _noteController.text.isEmpty ? null : _noteController.text,
        transactionType: _isDebt ? 'Debt_Added' : 'Debt_Paid',
      );

      await context.read<AppProvider>().addTransaction(transaction);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة معاملة'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات العميل',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('الاسم', widget.customer.name),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'الدين الحالي',
                        '${widget.customer.currentTotalDebt.toStringAsFixed(2)} دينار',
                        valueColor: widget.customer.currentTotalDebt > 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('إضافة دين'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('تسديد دين'),
                    icon: Icon(Icons.remove),
                  ),
                ],
                selected: {_isDebt},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isDebt = newSelection.first;
                  });
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  hintText: 'أدخل المبلغ',
                  suffixText: 'دينار',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]*\.?[0-9]*')),
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال المبلغ';
                  }
                  final number = double.tryParse(value);
                  if (number == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  if (number <= 0) {
                    return 'يجب أن يكون المبلغ أكبر من صفر';
                  }
                  if (number > 1000000000) {
                    return 'المبلغ أكبر من الحد المسموح به';
                  }
                  if (!_isDebt && number > widget.customer.currentTotalDebt) {
                    return 'المبلغ المدخل أكبر من الدين الحالي';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                  hintText: 'أدخل ملاحظات إضافية (اختياري)',
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('حفظ', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
