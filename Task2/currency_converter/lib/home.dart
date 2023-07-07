import 'package:http/http.dart' as http;
// import 'dart:ui';
import "package:flutter/material.dart";
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Future<void> getphoto() async {
    final response = await http.get(
      Uri.parse(
          "https://api.freecurrencyapi.com/v1/latest?apikey=C2TcvBNYJ9kAI4qFi8mQRpCWF91X2StHveYZTc8u"),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = convert.jsonDecode(response.body);
        if (f == 0) {
          currency.addAll((data['data'].keys).toList());
        }

        f = 1;
      });
    } else {
      print("Error...");
    }
  }

  var data;
  int f = 0;
  late List<String> currency = [];
  @override
  void initState() {
    getphoto();

    super.initState();
  }

  String fcurr = "INR";
  String tcurr = "USD";
  TextEditingController con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
        centerTitle: true,
      ),
      body: data == null || data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          onChanged: <String>(newvalue) {
                            setState(() {
                              fcurr = newvalue;
                            });
                          },
                          value: fcurr.isEmpty ? null : fcurr,
                          isDense: true,
                          menuMaxHeight: 350,
                          items: currency.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                        IconButton.filled(
                          onPressed: () {
                            getphoto();
                          },
                          splashColor: Colors.amber,
                          color: Colors.purple,
                          icon: Icon(
                            Icons.refresh_rounded,
                          ),
                          iconSize: 35,
                        ),
                        DropdownButton<String>(
                          onChanged: <String>(newvalue) {
                            setState(() {
                              tcurr = newvalue;
                            });
                          },
                          value: tcurr.isNotEmpty ? tcurr : null,
                          menuMaxHeight: 350,
                          items: currency.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 360,
                      height: 300,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    fcurr,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20),
                                  ),
                                  InkWell(
                                    child: Icon(Icons.compare_arrows_rounded),
                                    onTap: () {
                                      setState(() {
                                        String temp = fcurr;
                                        fcurr = tcurr;
                                        tcurr = temp;
                                      });
                                    },
                                  ),
                                  Text(
                                    tcurr,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 250,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Enter Price",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          suffixText: "${fcurr}",
                                          suffixStyle:
                                              TextStyle(color: Colors.green)),
                                      controller: con,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                    ),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(8),
                                    // ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                              Text(
                                "Result",
                                style: TextStyle(
                                    fontSize: 17,
                                    decoration: TextDecoration.underline,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                con.text.toString() != ""
                                    ? "${(double.parse(con.text.toString()) * data['data'][tcurr] / data['data'][fcurr]).toStringAsFixed(2)}"
                                        " ${tcurr} "
                                    : "${tcurr}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 30),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                        color: Colors.purple.shade50,
                        elevation: 7,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Latest Price",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: ListTile(
                              leading: Icon(Icons.currency_bitcoin_rounded),
                              tileColor: Color.fromARGB(255, 225, 200, 244),
                              titleTextStyle:
                                  TextStyle(color: Colors.green, fontSize: 20),
                              title: Text("1 ${fcurr}"),
                              trailing: Text(
                                "${(data['data'][currency[index]] / data['data'][fcurr]).toStringAsFixed(3)} ${currency[index]}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: currency.length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.all(8),
            ),
    );
  }
}
