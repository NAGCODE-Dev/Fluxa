import 'package:financas/app/app.dart';
import 'package:financas/data/datasources/fake_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renderiza a tela de boas-vindas', (tester) async {
    await tester.pumpWidget(
      FinancasApp(datasource: FakeLocalDatasource()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Olá, bem-vindo'), findsOneWidget);
    expect(find.text('Privacidade primeiro'), findsOneWidget);
    expect(find.text('Como você quer ser chamado?'), findsOneWidget);
  });
}
