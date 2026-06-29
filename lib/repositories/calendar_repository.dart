import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/models/calendar_event.dart';

class CalendarRepository {
  const CalendarRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<CalendarEventModel> listCalendarEvents() {
    return _localDatasource.getCalendarEvents();
  }

  Future<void> saveCalendarEvent(CalendarEventModel event) {
    return _localDatasource.saveCalendarEvent(event);
  }

  Future<void> deleteCalendarEvent(String eventId) {
    return _localDatasource.deleteCalendarEvent(eventId);
  }
}
