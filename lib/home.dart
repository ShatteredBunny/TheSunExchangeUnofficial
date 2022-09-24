import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_sun_exchange_unofficial/info.dart';
import 'package:the_sun_exchange_unofficial/model/dashboard.dart';
import 'package:the_sun_exchange_unofficial/model/dashboard_totals.dart';
import 'package:the_sun_exchange_unofficial/user.dart';

import 'api.dart';
import 'cache.dart';
import 'deposit.dart';
import 'model/project_dashboard.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Dashboard>(
        future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot<Dashboard> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = _buildDashboard(snapshot.data);
          } else if (snapshot.hasError) {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ]);
          } else {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading data...'),
                  ),
                ]);
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard'),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InfoWidget())),
                      icon: const Icon(Icons.info)),
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserWidget())),
                      icon: const Icon(Icons.person)),
                ],
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: Center(child: SingleChildScrollView(child: child)));
        });
  }

  Widget _buildDashboard(Dashboard? data) {
    DashboardTotals? total;
    if (data != null && data.totals.isNotEmpty) {
      total = data.totals.firstWhere((e) => e.currency == "XBT",
          orElse: () => data.totals.first);
    }
    return Column(children: <Widget>[
      _buildOverview(total),
      _buildWallet(data?.totals ?? []),
      _buildCells(data?.projects ?? []),
    ]);
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
            ...children,
          ])),
    );
  }

  Widget _buildOverview(DashboardTotals? total) {
    return _buildCard("My Solar Power Plant", [
      Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth()
        },
        children: [
          TableRow(children: [
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Total energy generated",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "+ ${(total?.totalEnergyGenerated ?? 0).toStringAsFixed(2)} kWh",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ]),
          TableRow(children: [
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Total carbon reduced",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "+ ${((total?.totalEnergyGenerated ?? 0) * 1.0292).toStringAsFixed(2)} kg CO₂",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ]),
          TableRow(children: [
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Total generation capacity",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "+ ${(total?.totalGenerationCapacity ?? 0).toStringAsFixed(2)} W",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ]),
        ],
      ),
      Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Last updated: ${total?.lastDistributionDate ?? 'never'}",
            textScaleFactor: 0.8,
          )),
    ]);
  }

  Widget _buildWallet(List<DashboardTotals> totals) {
    if (totals.isEmpty) {
      totals.add(DashboardTotals(
          totalEarnedToDate: 0,
          outstandingBalance: 0,
          totalUnprocessedPayments: 0,
          totalEnergyGenerated: 0,
          totalGenerationCapacity: 0,
          totalPaid: 0,
          currency: "XBT",
          lastDistributionDate: "never"));
    }
    return _buildCard("Wallet", [
      Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        children: [
          TableRow(children: [
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Balances",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: totals
                        .map((e) => Text(
                              "${e.outstandingBalance} ${e.currency == "XBT" ? "₿" : e.currency}",
                              style: TextStyle(
                                  color: e.currency == "XBT"
                                      ? Colors.orange
                                      : Colors.green,
                                  fontWeight: FontWeight.bold),
                            ))
                        .toList())),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DepositWidget()));
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text("Deposit funds"))),
            ),
          ]),
        ],
      ),
    ]);
  }

  Widget _buildCells(List<ProjectDashboard> projects) {
    List<Widget> ps = projects.map((e) => _buildProject(e)).toList();
    for (int i = ps.length - 1; i > 0; i--) {
      ps.insert(i, const Divider());
    }
    return _buildCard("My Solar Cells", ps);
  }

  Widget _buildProject(ProjectDashboard project) {
    List<Widget> earnings = project.projectEarnings
        .map((e) => Expanded(
                child: Text(
              "+ ${e.rentalEarned.toStringAsFixed(e.currency == "XBT" ? 8 : 2)} ${e.currency == "XBT" ? "₿" : e.currency}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: e.currency == "XBT" ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.bold),
            )))
        .toList();
    if (earnings.isEmpty) {
      earnings.insert(
          0,
          const Expanded(
              child: Text(
            "-",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          )));
    }
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                project.displayName,
                textAlign: TextAlign.left,
                textScaleFactor: 1.1,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.25,
                      imageUrl: Cache.get()
                          .getProjectSync(project.urlSlug)!
                          .mainImage
                          .url)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            "${project.cellsOwned} cells",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.2,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                          Expanded(
                              child: Text(
                            "+ ${project.generatedKWhToDate.toStringAsFixed(2)} kWh",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.2,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                        ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            "- ${project.costOfCellsOwned} ZAR",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )),
                          ...earnings,
                        ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _buildStatus(project.status)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("Status: ${project.statusMessage ?? "-"}")),
                  ],
                ),
              )
            ],
          )
        ]));
  }

  Widget _buildStatus(String status) {
    switch (status) {
      case "OPEN":
        {
          return const Text(
            "NOW AVAILABLE",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          );
        }
      case "CLOSED":
        {
          return const Text(
            "INSTALLING SOLAR CELLS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          );
        }
      case "PRODUCTION":
        {
          return Text(
            "GENERATING SOLAR POWER",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          );
        }
      case "PROVISIONAL_COMING_SOON":
        {
          return const Text(
            "COMING SOON",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          );
        }
      default:
        {
          return Text(status);
        }
    }
  }

  Future<Dashboard> _fetch() async {
    await Cache.get().loadProjects();
    return await Api.get().dashboard(await Cache.get().getMemberId());
  }
}
