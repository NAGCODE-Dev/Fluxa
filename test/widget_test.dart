import 'package:flutter_test/flutter_test.dart';
import 'package:financas/app/app.dart';
import 'package:financas/data/datasources/fake_local_datasource.dart';

void main() {
  testWidgets('carrega a shell inicial do app', (tester) async {
    await tester.pumpWidget(
      FinancasApp(datasource: FakeLocalDatasource()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Olá, bem-vindo'), findsOneWidget);
    expect(find.text('Privacidade primeiro'), findsOneWidget);
  });
}
