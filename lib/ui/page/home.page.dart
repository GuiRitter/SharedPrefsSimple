import 'dart:convert';

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Column,
        CrossAxisAlignment,
        ElevatedButton,
        Icon,
        IconButton,
        Icons,
        ListTile,
        MainAxisSize,
        MediaQuery,
        Row,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        StatelessWidget,
        Text,
        TextEditingController,
        TextFormField,
        ValueListenableBuilder,
        ValueNotifier,
        Widget;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:shared_prefs_simple/model/pref.dart' show Pref;

const dataKey = 'DATA';

final emptyListAsString = jsonEncode(
  <Pref>[],
);

final TextEditingController keyController = TextEditingController();

final ValueNotifier<List<Pref>> prefListNotifier = ValueNotifier(
  <Pref>[],
);

final TextEditingController valueController = TextEditingController();

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  void add() async {
    final key = keyController.text;
    final value = valueController.text;

    if (key.isEmpty || value.isEmpty) {
      return;
    }

    final prefList = await getPrefList();

    prefList.add(
      Pref(
        key: key,
        value: value,
      ),
    );

    await setPrefList(
      prefList,
    );

    await refresh();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final mediaSize = MediaQuery.of(
      context,
    ).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: add,
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: refresh,
          ),
        ],
        title: Text(
          'Shared Prefs Simple',
        ),
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: keyController,
            ),
            TextFormField(
              controller: valueController,
            ),
            ValueListenableBuilder(
              valueListenable: prefListNotifier,
              builder: (
                context,
                prefList,
                _,
              ) =>
                  SingleChildScrollView(
                child: Column(
                  children: buildPrefList(
                    prefList,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPrefList(
    List<Pref> prefList,
  ) =>
      prefList
          .map(
            (
              pref,
            ) =>
                ListTile(
              title: Text(
                pref.key,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: Icon(
                      Icons.copy,
                    ),
                    onPressed: () => Clipboard.setData(
                      ClipboardData(
                        text: pref.value,
                      ),
                    ),
                  ),
                  Text(
                    '\u2001',
                  ),
                  ElevatedButton(
                    child: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {},
                    onLongPress: () => delete(
                      prefList,
                      pref,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList();

  delete(
    List<Pref> prefList,
    Pref pref,
  ) async {
    prefList.removeWhere(
      (
        element,
      ) =>
          element.key == pref.key,
    );

    await setPrefList(
      prefList,
    );

    await refresh();
  }

  Future<List<Pref>> getPrefList() async {
    final prefs = await SharedPreferences.getInstance();

    var dataAsString = prefs.getString(
          dataKey,
        ) ??
        emptyListAsString;

    final prefList = (jsonDecode(
      dataAsString,
    ) as List<dynamic>)
        .map(
          (
            json,
          ) =>
              Pref.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();

    return prefList;
  }

  Future<void> refresh() async {
    final prefList = await getPrefList();

    prefListNotifier.value = prefList;
  }

  Future<void> setPrefList(
    List<Pref> prefList,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final dataAsString = jsonEncode(
      prefList,
    );

    prefs.setString(
      dataKey,
      dataAsString,
    );
  }
}
