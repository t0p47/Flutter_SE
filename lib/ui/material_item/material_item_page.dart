import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se_test/model/material_item.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MaterialItemPage extends StatefulWidget {
  static const routeName = '/materialItemPage';

  @override
  _MaterialItemPageState createState() => _MaterialItemPageState();
}

class _MaterialItemPageState extends State<MaterialItemPage> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    final MaterialItem matItem = ModalRoute.of(context).settings.arguments;

    String imageUrl = matItem.enclosures[0].variant.url;
    /*
    * CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
        imageUrl: imageUrl != null ? imageUrl : '',
        errorWidget: (context, url, error) => Icon(Icons.error),
      )
    * */

    return Scaffold(
      appBar: AppBar(
        title: Text('Главные'),
      ),
      body: ListView(
        children: <Widget>[
          Text(matItem.title),
          //TODO: Cached network image


          //Image.network(matItem.enclosures[0].variant.url),
          CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
              value: progress.progress,
            ),
            imageUrl: imageUrl != null ? imageUrl : '',
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          Text(matItem.enclosures[0].description),
          Container(
            //TODO: WebViewheight
            height: 1000.0,
            child: WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _webViewController = webViewController;

                var cssData = await DefaultAssetBundle.of(context)
                    .loadString('assets/materials_webview.css');

                _webViewController.loadUrl(Uri.dataFromString(
                        _prepareHtmlPage(matItem, cssData),
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'))
                    .toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  _prepareHtmlPage(MaterialItem matItem, String css) {
    var buffer = new StringBuffer();

    buffer.write(
        "<html><head><meta name=\"viewport\" content=\"initial-scale=1, width=device-width\", user-scalable=\"no, target-densitydpi=device-dpi\"/>");
    buffer.write("<style type=\"text/css\">");

    buffer.write(css);

    buffer.write("</style></head>");
    buffer.write(
        "<body onload=\"RenderedWebViewHeight.postMessage(document.body.clientHeight);\">");
    buffer.write("<div class=\"b-post\">");
    buffer.write(matItem.content.value);
    buffer.write("</div>");

    buffer.write("</body></html>");

    return buffer.toString();
  }
}
