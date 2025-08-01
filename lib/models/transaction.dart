// models/transaction.dart
class DebtTransaction {
  final int? id;
  final int customerId;
  final DateTime transactionDate;
  final double amountChanged;
  final double? newBalanceAfterTransaction;
  final String? transactionNote;
  final String transactionType;
  final String? description;
  final int? invoiceId;
  final DateTime createdAt;

  DebtTransaction({
    this.id,
    required this.customerId,
    DateTime? transactionDate,
    required this.amountChanged,
    this.newBalanceAfterTransaction,
    this.transactionNote,
    required this.transactionType,
    this.description,
    this.invoiceId,
    DateTime? createdAt,
  })  : transactionDate = transactionDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'transaction_date': transactionDate.toIso8601String(),
      'amount_changed': amountChanged,
      'new_balance_after_transaction': newBalanceAfterTransaction,
      'transaction_note': transactionNote,
      'transaction_type': transactionType,
      'description': description,
      'invoice_id': invoiceId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DebtTransaction.fromMap(Map<String, dynamic> map) {
    return DebtTransaction(
      id: map['id'] as int,
      customerId: map['customer_id'] as int,
      transactionDate: DateTime.parse(map['transaction_date'] as String),
      amountChanged: map['amount_changed'] as double,
      newBalanceAfterTransaction:
          map['new_balance_after_transaction'] as double?,
      transactionNote: map['transaction_note'] as String?,
      transactionType: map['transaction_type'] as String,
      description: map['description'] as String?,
      invoiceId: map['invoice_id'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  DebtTransaction copyWith({
    int? id,
    int? customerId,
    DateTime? transactionDate,
    double? amountChanged,
    double? newBalanceAfterTransaction,
    String? transactionNote,
    String? transactionType,
    String? description,
    int? invoiceId,
    DateTime? createdAt,
  }) {
    return DebtTransaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      transactionDate: transactionDate ?? this.transactionDate,
      amountChanged: amountChanged ?? this.amountChanged,
      newBalanceAfterTransaction:
          newBalanceAfterTransaction ?? this.newBalanceAfterTransaction,
      transactionNote: transactionNote ?? this.transactionNote,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      invoiceId: invoiceId ?? this.invoiceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
