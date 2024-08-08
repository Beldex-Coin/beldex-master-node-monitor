import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_node_monitor/generated/l10n.dart';
import 'package:master_node_monitor/src/widgets/base_page.dart';

class FaqPage extends BasePage {
  @override
  String get title => S.current.title_faq;

  @override
  Widget body(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        final faqItems = jsonDecode(snapshot.data.toString()) as List;

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final itemTitle = faqItems[index]['question'].toString();
            final itemChild = faqItems[index]['answer'].toString();

            return Theme(
              data: Theme.of(context).copyWith(hintColor: Colors.green,textSelectionTheme: TextSelectionThemeData(
                  selectionColor: Colors.green
              )),
              child: Card(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  title: Text(itemTitle),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                itemChild,
                                textAlign: TextAlign.justify,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) =>
              Divider(color: Theme.of(context).dividerTheme.color, height: 1.0),
          itemCount: faqItems == null ? 0 : faqItems.length,
        );
      },
      future: rootBundle.loadString(getFaqPath(context)),
    );
  }

  String getFaqPath(BuildContext context) {
    return 'assets/faq/faq_en.json';
  }
}