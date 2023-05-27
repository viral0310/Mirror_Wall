import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controllerProgressBar;
  final GlobalKey inAppWedViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;

  final TextEditingController searchController = TextEditingController();

  String searchedText = "";
  bool isSelected = true;
  late PullToRefreshController pullToRefreshController;
  List<String> allBookmarks = [];
  late bool _loading;
  late double _progressValue;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController!.reload();
          }

          if (Platform.isIOS) {
            inAppWebViewController!.loadUrl(
                urlRequest:
                    URLRequest(url: await inAppWebViewController!.getUrl()));
          }
        });

    controllerProgressBar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controllerProgressBar.forward();

    _loading = false;
    _progressValue = 0.0;
  }

  @override
  void dispose() {
    controllerProgressBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8),
                child: Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hii,",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: const Center(
                                  child: Text("All BookMarks"),
                                ),
                                content: /*Column(
                    mainAxisSize: MainAxisSize.min,
                    children: allBookmarks
                        .map((e) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();

                              inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.parse(e),
                                ),
                              );
                            },
                            child: Text(e)))
                        .toSet()
                        .toList(),
                  ),*/
                                    SizedBox(
                                  height: 350,
                                  width: 350,
                                  child: ListView.separated(
                                      itemBuilder: (context, i) {
                                        return ListTile(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await inAppWebViewController!
                                                .loadUrl(
                                              urlRequest: URLRequest(
                                                url: Uri.parse(allBookmarks[i]),
                                              ),
                                            );
                                          },
                                          title: Text(allBookmarks[i]),
                                        );
                                      },
                                      separatorBuilder: (context, i) =>
                                          const Divider(
                                            color: Colors.grey,
                                            indent: 20,
                                            endIndent: 2,
                                          ),
                                      itemCount: allBookmarks.length),
                                )),
                          );
                        },
                        icon: const Icon(Icons.bookmark),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person_pin_circle_rounded,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Expanded(
                  flex: 1,
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (val) async {
                      searchedText = val;
                      Uri uri = Uri.parse(searchedText);
                      if (uri.scheme.isEmpty) {
                        uri = Uri.parse(
                            "https://www.google.com/search?q=$searchedText");

                        await inAppWebViewController!
                            .loadUrl(urlRequest: URLRequest(url: uri));
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Search your website...",
                      focusColor: Colors.deepOrange,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              // _loading
              //     ? LinearProgressIndicator(
              //         /*value: controllerProgressBar.value,
              //   color: Colors.indigo,
              //   backgroundColor: Colors.white,*/
              //         backgroundColor: Colors.white,
              //         valueColor:
              //             const AlwaysStoppedAnimation<Color>(Colors.red),
              //         color: Colors.indigo,
              //         value: _progressValue,
              //       )
              //     : Container(),
              Expanded(
                flex: 22,
                child: InAppWebView(
                  pullToRefreshController: pullToRefreshController,
                  initialOptions: options,
                  key: inAppWedViewKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse("https://www.google.co.in"),
                  ),
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    await pullToRefreshController.endRefreshing();

                    setState(
                      () {
                        searchController.text = url.toString();
                        setState(
                          () {
                            if (searchController.text ==
                                "https://www.google.co.in/") {
                              searchController.text = "";
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        color: Colors.deepOrange.withOpacity(0.6),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                inAppWebViewController!.reload();
                setState(() {
                  controllerProgressBar.reset();
                  controllerProgressBar.value;
                });
                /*setState(() {
                  _loading = !_loading;
                  _updateProgress();
                });*/
              },
              icon: const Icon(
                Icons.refresh,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () async {
                /*setState(() {
                      isSelected = !isSelected;
                    });*/

                if (await inAppWebViewController!.canGoBack()) {
                  await inAppWebViewController!.goBack();
                }
                /* setState(() {
                  _loading = !_loading;
                  _updateProgress();
                });*/
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController!.loadUrl(
                  urlRequest: URLRequest(
                    url: Uri.parse("https://www.google.co.in"),
                  ),
                );
              },
              icon: const Icon(
                Icons.home,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (await inAppWebViewController!.canGoForward()) {
                  await inAppWebViewController!.goForward();
                }
              },
              icon: const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () async {
                Uri? uri = await inAppWebViewController!.getUrl();

                allBookmarks.add(uri.toString());
              },
              icon: const Icon(
                Icons.bookmark_add_outlined,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  /* void _updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer t) {
        setState(
          () {
            _progressValue += 0.1;
            // we "finish" downloading here
            if (_progressValue.toStringAsFixed(1) == '1.0') {
              _loading = false;
              t.cancel();
              return;
            }
          },
        );
      },
    );
  }*/
}
