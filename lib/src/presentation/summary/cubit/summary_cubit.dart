import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:paisa/src/data/expense/model/expense.dart';
import 'package:paisa/src/domain/expense/use_case/expense_use_case.dart';

part 'summary_state.dart';

@injectable
class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit(this.useCase) : super(SummaryInitial());

  final GetExpensesUseCase useCase;
  void fetchExpenses() {
    final expense = useCase.call();
    emit(SummaryExpenses(expense));
  }
}