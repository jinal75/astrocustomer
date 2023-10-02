import 'package:AstroGuru/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GetBuilder<KundliController>(builder: (kundliController) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Planets',
                          style: Get.textTheme.bodyText2,
                        ).translate(),
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: kundliController.planetTab.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  kundliController.selectPlanetTab(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: kundliController.planetTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                                        border: Border.all(color: kundliController.planetTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(kundliController.planetTab[index].title, style: TextStyle(fontSize: 13)).translate()),
                                ),
                              );
                            }),
                      ),
                      kundliController.planetTab[0].isSelected
                          ? kundliController.ascendantDetails.name == null
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 248, 242, 205),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: DataTable(
                                    columnSpacing: 20,
                                    dataTextStyle: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    horizontalMargin: 10,
                                    headingRowHeight: 48,
                                    columns: [
                                      DataColumn(
                                        label: Text('Planet', textAlign: TextAlign.center).translate(),
                                      ),
                                      DataColumn(label: Text('Sign', textAlign: TextAlign.center).translate()),
                                      DataColumn(
                                        label: Text('Sign\nLord', textAlign: TextAlign.center).translate(),
                                      ),
                                      DataColumn(label: Text('Degree', textAlign: TextAlign.center).translate()),
                                      DataColumn(label: Text('House', textAlign: TextAlign.center).translate()),
                                    ],
                                    border: TableBorder(
                                      verticalInside: BorderSide(color: Colors.grey),
                                      horizontalInside: BorderSide(color: Colors.grey),
                                    ),
                                    rows: [
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.ascendantDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ascendantDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ascendantDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ascendantDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ascendantDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.sunDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.sunDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.sunDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.sunDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.sunDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.moonDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.moonDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.moonDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.moonDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.moonDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.mercuryDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.mercuryDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.mercuryDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.mercuryDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.mercuryDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.venusDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.venusDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.venusDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.venusDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.venusDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.marsDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.marsDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.marsDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.marsDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.marsDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.jupiterDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.jupiterDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.jupiterDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.jupiterDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.jupiterDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.saturnDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.saturnDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.saturnDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.saturnDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.saturnDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.rahuDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.rahuDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.rahuDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.rahuDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.rahuDetails.house}').translate())),
                                        ],
                                      ),
                                      DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        cells: [
                                          DataCell(Center(child: Text('${kundliController.ketuDetails.name}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ketuDetails.sign}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ketuDetails.signLord}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ketuDetails.fullDegree!.toStringAsFixed(2)}').translate())),
                                          DataCell(Center(child: Text('${kundliController.ketuDetails.house}').translate())),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                          : Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 242, 205),
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DataTable(
                                  columnSpacing: 20,
                                  dataTextStyle: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                  horizontalMargin: 10,
                                  headingRowHeight: 48,
                                  columns: [
                                    DataColumn(
                                      label: Text('Planet', textAlign: TextAlign.center).translate(),
                                    ),
                                    DataColumn(label: Text('Nakshatra', textAlign: TextAlign.center).translate()),
                                    DataColumn(
                                      label: Text('Nakshatra\nLord', textAlign: TextAlign.center).translate(),
                                    ),
                                    DataColumn(label: Text('House', textAlign: TextAlign.center).translate()),
                                  ],
                                  border: TableBorder(
                                    verticalInside: BorderSide(color: Colors.grey),
                                    horizontalInside: BorderSide(color: Colors.grey),
                                  ),
                                  rows: [
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.ascendantDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ascendantDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ascendantDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ascendantDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.sunDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.sunDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.sunDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.sunDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.moonDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.moonDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.moonDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.moonDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.mercuryDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.mercuryDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.mercuryDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.mercuryDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.venusDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.venusDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.venusDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.venusDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.marsDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.marsDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.marsDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.marsDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.jupiterDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.jupiterDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.jupiterDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.jupiterDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.saturnDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.saturnDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.saturnDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.saturnDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.rahuDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.rahuDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.rahuDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.rahuDetails.house}').translate())),
                                      ],
                                    ),
                                    DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) {
                                          return Colors.white;
                                        },
                                      ),
                                      cells: [
                                        DataCell(Center(child: Text('${kundliController.ketuDetails.name}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ketuDetails.nakshatra}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ketuDetails.nakshatraLord}').translate())),
                                        DataCell(Center(child: Text('${kundliController.ketuDetails.house}').translate())),
                                      ],
                                    )
                                  ]),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ));
  }
}
