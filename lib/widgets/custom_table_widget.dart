import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<AppTableColumn> columns;
  final List<TableRow> rows;

  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            /// ================= HEADER =================
            Container(
              width: constraints.maxWidth,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                columnWidths: {
                  for (int i = 0; i < columns.length; i++)
                    i: FlexColumnWidth(columns[i].flex),
                },
                children: [
                  TableRow(
                    children: columns.map((col) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          col.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A5568),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// ================= BODY =================
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: {
                    for (int i = 0; i < columns.length; i++)
                      i: FlexColumnWidth(columns[i].flex),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: rows,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class AppTableColumn {
  final String title;
  final double flex;

  AppTableColumn({
    required this.title,
    required this.flex,
  });
}
