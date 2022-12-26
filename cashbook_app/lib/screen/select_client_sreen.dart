import 'package:cashbook_app/screen/add_client_screen.dart';
import 'package:cashbook_app/screen/manage_client_screen.dart';
import 'package:flutter/material.dart';

class SelectClintScreen extends StatefulWidget {
  static const String routeName = '/SelectClintScreen';
  SelectClintScreen({super.key});

  @override
  State<SelectClintScreen> createState() => _SelectClintScreenState();
}

class _SelectClintScreenState extends State<SelectClintScreen> {
  TextEditingController editingController = TextEditingController();
  List duplicateItems = [
    {
      'cmobileno': 123432,
      'cname': "kfjs",
    },
    {
      'cmobileno': 593583,
      'cname': "vnxn",
    },
    {
      'cmobileno': 4221121,
      'cname': "ada",
    },
    {
      'cmobileno': 020328,
      'cname': "yash",
    },
    {
      'cmobileno': 123432,
      'cname': "kfjs",
    },
    {
      'cmobileno': 593583,
      'cname': "vnxn",
    },
    {
      'cmobileno': 4221121,
      'cname': "ada",
    },
    {
      'cmobileno': 020328,
      'cname': "yash",
    },
    {
      'cmobileno': 123432,
      'cname': "kfjs",
    },
    {
      'cmobileno': 593583,
      'cname': "vnxn",
    },
    {
      'cmobileno': 4221121,
      'cname': "ada",
    },
    {
      'cmobileno': 020328,
      'cname': "yash",
    },
  ];
  List items = [];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    print(dummySearchList);
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (item["cname"].contains(query)) {
          dummyListData.add(item);
        } else if (item["cmobileno"].toString().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  var selectedClient;

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("select client"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ManageClientScreen.routeName);
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomSearchbarTextfield(),
            customClientListview(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.of(context).pushNamed(AddclientSceen.routeName);
        },
        label: const Text('Add Client'),
        icon: const Icon(Icons.add),
        // backgroundColor: Colors.pink,
      ),
    );
  }

  Expanded customClientListview() {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(items[index]["cname"]),
            subtitle: Text("+91 ${items[index]["cmobileno"]}"),
            value: items[index],
            groupValue: selectedClient,
            // toggleable: true,
            onChanged: (value) {
              setState(() {
                // value contain map of perticluter index
                selectedClient = value;
                // print(value);
              });

              Navigator.of(context).pop(selectedClient);
            },
          );
        },
      ),
    );
  }

  TextField CustomSearchbarTextfield() {
    return TextField(
      onChanged: (value) {
        filterSearchResults(value);
      },
      controller: editingController,
      cursorColor: Colors.black,
      style: const TextStyle(
          // letterSpacing: 1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        labelText: "Search",
        labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        hintStyle: TextStyle(fontSize: 13),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }
}
