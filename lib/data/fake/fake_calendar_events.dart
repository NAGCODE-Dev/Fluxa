import 'package:fluxa/models/calendar_event.dart';

final fakeCalendarEvents = [
  CalendarEventModel(
    id: 'event-card-due',
    type: 'card_due',
    title: 'Vencimento Nubank',
    description: 'Pagamento da fatura principal',
    eventDate: DateTime(2026, 7, 3),
    amount: 2340,
  ),
  CalendarEventModel(
    id: 'event-sub-spotify',
    type: 'subscription_charge',
    title: 'Cobrança Spotify',
    description: 'Assinatura mensal',
    eventDate: DateTime(2026, 7, 2),
    amount: 21.90,
  ),
];
