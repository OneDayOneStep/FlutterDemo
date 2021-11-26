import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());
final saved = <WordPair>{}; // 收藏的单词列表 set 类型

// 主程序 - 无状态部件
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { // 部件实现
    return MaterialApp( // 创建一个 MaterialApp
      // 主题
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      // MaterialApp 主体 - StatefulWidgetObj
      home: const StatefulWidgetObj(),
    );
  }
}

// MaterialApp 主体 - 状态部件A
class StatefulWidgetObj extends StatefulWidget {
  const StatefulWidgetObj({Key? key}) : super(key: key);
  @override
  createState() => RandomWordsState(); // 创建组件状态 RandomWordsState
}

// 收藏页面主体 - 状态部件
class StatefulWidgetObjFavour extends StatefulWidget {
  const StatefulWidgetObjFavour({Key? key}) : super(key: key);
  @override
  createState() => RandomWordsStateFavour(); // 创建组件状态 RandomWordsState
}

class RandomWordsStateFavour extends State<StatefulWidgetObjFavour> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final tiles = saved.map((pair) {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: TextButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text("Remove"),
          style: TextButton.styleFrom(primary: Colors.black),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Remove this word from favour？'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        saved.remove(pair);
                      });
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        )
      );
    },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favour Words'),
      ),
      body: ListView(children: divided),
    );
  }
}

// 随机字符组件 继承自 状态部件A
class RandomWordsState extends State<StatefulWidgetObj> {
  final _suggestions = <WordPair>[]; // 单词列表 数组

  final TextStyle _biggerFont = const TextStyle(fontSize: 20.0);

  // 单词操作事件
  void _pushSaved() {
    // 导航到收藏页面
    Navigator.of(context).push(
      MaterialPageRoute(
        // 收藏页面
        builder: (context) => const StatefulWidgetObjFavour()
      ),
    ).then((v) => setState(() {})); // 主动刷新页面
  }

  @override
  Widget build(BuildContext context) { // 重写 build
    return Scaffold( // build 页面
      appBar: AppBar( // top
        title: const Text('Word List'),
        actions: <Widget>[
          Offstage(
            offstage: saved.isEmpty,
            child: TextButton.icon(
                onPressed: _pushSaved,
                icon: const Icon(Icons.favorite),
                label: Text(saved.length.toString()),
                style: TextButton.styleFrom(primary: Colors.black, textStyle: const TextStyle(fontSize: 18))
            )
          )
        ]
      ),
      // 页面内容
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider(); // 分割线
          }
          final index = i ~/ 2;
          if (index >= _suggestions.length) { // 无限加载数据
            _suggestions.addAll(generateWordPairs().take(10));
          }
          // 创建行
          return _buildRow(_suggestions[index]);
        },
      )
    );
  }

  // 单独一行
  Widget _buildRow(WordPair pair) {
    final alreadySaved = saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.star_border,
        color: alreadySaved ? Colors.red : Colors.black,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            saved.remove(pair);
          } else {
            saved.add(pair);
          }
        });
      }
    );
  }
} // 随机字符组件