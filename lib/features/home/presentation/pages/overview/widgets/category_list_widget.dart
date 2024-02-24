// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:paisa/core/common.dart';
import 'package:paisa/features/category/domain/entities/category.dart';
import 'package:paisa/features/transaction/domain/entities/transaction_entity.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({
    super.key,
    required this.categoryGrouped,
    required this.totalExpense,
  });

  final List<MapEntry<CategoryEntity, List<TransactionEntity>>> categoryGrouped;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryGrouped.length,
      itemBuilder: (context, index) {
        final MapEntry<CategoryEntity, List<TransactionEntity>> map =
            categoryGrouped[index];
        return InkWell(
          onTap: () {
            //TODO:
            /* context.pushNamed(
              expensesByCategoryName,
              pathParameters: {'cid': map.key.superId.toString()},
            ); */
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        backgroundColor:
                            Color(map.key.color ?? Colors.amber.shade100.value)
                                .withOpacity(0.12),
                        child: Icon(
                          size: 18,
                          color: Color(
                              map.key.color ?? Colors.amber.shade100.value),
                          IconData(
                            map.key.icon ?? 0,
                            fontFamily: fontFamilyName,
                            fontPackage: fontFamilyPackageName,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(map.key.name ?? ''),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: map.value.total / totalExpense,
                              color: Color(
                                  map.key.color ?? Colors.amber.shade100.value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(map.value.total.toFormateCurrency(context))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
