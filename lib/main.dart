import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_se_test/db/DBProvider.dart';
import 'package:flutter_se_test/di/injection_container.dart';
import 'package:flutter_se_test/model/material_item.dart';
import 'package:flutter_se_test/repository/material_item/material_item_repository.dart';
import 'package:flutter_se_test/ui/material_item/material_item.dart';
import 'package:flutter_se_test/ui/material_item/material_item_page.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:workmanager/workmanager.dart';
import 'package:yandex_ads_view/yandex_ads_view.dart';
import 'package:yandex_ads_view/yandex_interstitial_ad.dart';

/*void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter SQLite'),),
      body: FutureBuilder<List<MaterialItem>>(
        future: DBProvider.db.getLatestMaterials(),
        builder: (BuildContext context, AsyncSnapshot<List<MaterialItem>> snapshot){
          if(snapshot.hasData){
            print('Main: build: hasData: ${snapshot.toString()}');
            return Text('Main: build: hasData: ${snapshot.toString()}');
          }else{
            return Text('Main: build: no data');
          }
        },
      ),
    );
  }
}*/

StreamSubscription connectivitySubscription;
ConnectivityResult _previousResult;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /*Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager.registerOneOffTask("1", "SimpleTask", initialDelay: Duration(seconds: 10));*/

  runTimer();
  connectionCheck();

  initKiwi();
  runApp(App());
}

void runTimer() async{
  final scheduler = NeatPeriodicTaskScheduler(
    interval: Duration(seconds: 40),
    name: 'Hello timer',
    timeout: Duration(seconds: 5),

    //task: () async => print('Hello timer'),
    task: () async {
      print('Main: runTimer: showInterstitialAd');
      YandexInterstitialAd().showIntestitialAd();
    },

    minCycle: Duration(seconds: 5)
  );

  scheduler.start();
  await ProcessSignal.sigterm.watch().first;
  await scheduler.stop();
}

void connectionCheck(){
  connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
    if(connectivityResult == ConnectivityResult.none){
      print('Main: initState: no connection');
    }else if(_previousResult == ConnectivityResult.none){
      print('Main: initState: have connection');
    }

    _previousResult = connectivityResult;
  });
}

/*void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    print("Native called background task: $taskName");
    return Future.value(true);
  });
}*/

class App extends StatelessWidget {
  final materialItemRepository =
      kiwi.Container().resolve<MaterialItemRepository>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MaterialItemPage.routeName: (context) => MaterialItemPage(),
      },
      title: 'Sport-Express',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Главное'),
        ),
        body: BlocProvider(
          create: (context) => _previousResult == ConnectivityResult.none
            ? (MaterialItemBloc(materialItemRepository: materialItemRepository)..add(MaterialItemInitialFromDB()))
            : (MaterialItemBloc(materialItemRepository: materialItemRepository)..add(MaterialItemFetchNextPage())),

          child: HomePage(),
        ),
          bottomNavigationBar: Stack(
            children: [
              new Container(
                height: 55.0,
                color: Colors.transparent,
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Center(
                  child: Container(
                    width: 320.0,
                    height: 55.0,
                    child: YandexAdsView(
                      adType: 'banner',
                      onYandexAdsCreated: _onYandexBannerAdsCreated,
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  void _onYandexBannerAdsCreated(YandexAdsViewController controller){
    controller.setBannerAd();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MaterialItemBloc _materialItemBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _materialItemBloc = BlocProvider.of<MaterialItemBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaterialItemBloc, MaterialItemState>(
        builder: (context, state) {
      if (state is MaterialItemFailure) {
        return Center(
          child: Text('Failed to fetch materials'),
        );
      }
      if (state is MaterialItemSuccess) {
        print('Main: BlocBuilder: MaterialItemSuccess');
        if (state.materialItems.isEmpty) {
          return Center(
            child: Text('no materials'),
          );
        }
        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: GridView.builder(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index % 5 == 0 && index != 0) {
                print('Main: BlocBuilder: show nativeAd');
                return Wrap(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 320.0,
                        height: 150.0,
                        child: YandexAdsView(
                          adType: ('native'),
                          onYandexAdsCreated: _onYandexNativeAdsCreated,
                        ),
                      ),
                    ),
                    index >= state.materialItems.length
                        ? BottomLoader()
                        : GestureDetector(
                      //child: MaterialItemWidget(materialItem: state.materialItems[resIndex]),
                      child: _buildMatItem(state.materialItems[index]),
                      onTap: () {
                        print(state.materialItems[index].title + " clicked");
                        Navigator.pushNamed(context, MaterialItemPage.routeName,
                            arguments: state.materialItems[index]);
                      },
                    )
                  ],
                );

              }

              print(
                  'Main: BlocBuilder: matItem count: ${state.materialItems.length}');

              print('Main: BlocBuilder: matItem index: $index, title');
              return index >= state.materialItems.length
                  ? BottomLoader()
                  : GestureDetector(
                //child: MaterialItemWidget(materialItem: state.materialItems[resIndex]),
                child: _buildMatItem(state.materialItems[index]),
                onTap: () {
                  print(state.materialItems[index].title + " clicked");
                  Navigator.pushNamed(context, MaterialItemPage.routeName,
                      arguments: state.materialItems[index]);
                },
              );
            },
            //TODO: MaterialItem length(DB Unique)
            itemCount: state.materialItems.length,
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  bool _handleScrollNotification(ScrollNotification notification){
    if(notification is ScrollEndNotification && _scrollController.position.extentAfter == 0){
      print('Main: _handleScrollNotification: $_previousResult');
      if(_previousResult == ConnectivityResult.none){
        print('Main: _handleScrollNotification: MaterialItemGetOldPageFromDB');
        _materialItemBloc.add(MaterialItemGetOldPageFromDB());
      }else{
        print('Main: _handleScrollNotification: MaterialItemGetOldPageFromServer');
        _materialItemBloc.add(MaterialItemGetOldPageFromServer());
      }

    }
  }

  void _onYandexNativeAdsCreated(YandexAdsViewController controller) {
    controller.setNativeAd();
  }

  Widget _buildMatItem(MaterialItem matItem) {
    print(
        'Main: buildMatItem: title: ${matItem.title}, enclosure: ${matItem.enclosures}');

    String imageUrl;
    if (matItem.enclosures.length > 0) {
      imageUrl = matItem.enclosures[0].variant.url;
    }

    return GridTile(
      footer: Text(matItem.title),
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
        imageUrl: imageUrl != null ? imageUrl : '',
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void _onScroll() {

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    //print('Main: onScroll: maxScroll: $maxScroll, currentScroll: $currentScroll, threshold: $_scrollThreshold');
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print('Main: MaterialItemGetOldPage');
      _materialItemBloc.add(MaterialItemGetOldPage());
    }
  }*/
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

/*class MaterialItemWidget extends StatelessWidget{
  final MaterialItem materialItem;

  const MaterialItemWidget({Key key, @required this.materialItem}) : super(key: key);

  String imageUrl;
  if(materialItem.enclosures.length > 0){

  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(materialItem.title),
      dense: true,
    );
  }


}*/
