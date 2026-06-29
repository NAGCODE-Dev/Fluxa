import 'package:fluxa/models/transaction.dart';

final fakeTransactions = [
  TransactionModel(
    id: 'tx-1',
    title: 'Mercado Extra',
    description: 'Compras da semana',
    amount: -186.40,
    type: TransactionType.expense,
    occuredAt: DateTime(2026, 6, 28),
    sourceLabel: 'Débito Santander',
    category: 'Mercado',
  ),
  TransactionModel(
    id: 'tx-2',
    title: 'Salário',
    description: 'Recebimento mensal',
    amount: 3500.00,
    type: TransactionType.income,
    occuredAt: DateTime(2026, 6, 28),
    sourceLabel: 'Conta principal',
    category: 'Renda',
  ),
  TransactionModel(
    id: 'tx-3',
    title: 'Spotify',
    description: 'Assinatura',
    amount: -21.90,
    type: TransactionType.expense,
    occuredAt: DateTime(2026, 6, 27),
    sourceLabel: 'Nubank',
    category: 'Assinaturas',
  ),
  TransactionModel(
    id: 'tx-4',
    title: 'Uber',
    description: 'Deslocamento',
    amount: -27.50,
    type: TransactionType.expense,
    occuredAt: DateTime(2026, 6, 21),
    sourceLabel: 'Crédito Santander',
    category: 'Transporte',
  ),
];
