import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_food/models/api_result.dart';
import 'package:flutter_food/models/food_item.dart';
import 'package:flutter_food/services/api.dart';

//flutter pub add http
import 'package:http/http.dart' as http;

const apiBaseUrl = 'http://103.74.252.66:8888';
const apiGet = '$apiBaseUrl/';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<FootBall>? _FootballList;
  var _isLoading = false;
  String? _isError;

  @override
  void initState() {
    super.initState();
    _handleClickButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Image.asset('assets/images/logo.jpg',
                width: 500.0, fit: BoxFit.cover),
          ),
          // Container(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: _handleClickButton,
          //     child: const Text('GET FOOD DATA'),
          //   ),
          // ),
          Expanded(
            child: Stack(
              children: [
                if (_FootballList != null)
                  ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: _FootballList!.length,
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (_isError != null && !_isLoading)
                  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(_isError!),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _handleClickButton();
                              },
                              child: const Text('RETRY'))
                        ],
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleClickButton() async {
    setState(() {
      //_foodList = null;
      _isLoading = true;
    });

    // try{
    //   var output =  await Api().fetch();
    //   setState(() {
    //     _foodList = output.map<FoodItem>((item) {
    //       return FoodItem.formJson(item);
    //     }).toList();
    //     _isLoading = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     _isError = e.toString();
    //     _isLoading = false;
    //   });
    // }

//call API
    var response = await http.get(Uri.parse(apiGet));

    if (response.statusCode == 200) {
      // Json to Dart
      var output = jsonDecode(response.body);
      var apiResult = ApiResult.fromJson(output);
      if (apiResult.status == 'ok') {
        setState(() {
          _FootballList = apiResult.data.map<FootBall>((item) {
            return FootBall.formJson(item);
          }).toList();
          _isLoading = false;
        });
      } else {
        //error
        setState(() {
          _isLoading = false;
          _isError = apiResult.message;
        });
      }
    } else {
      //error
      setState(() {
        _isLoading = false;
        _isError = '[${response.statusCode}]Network connection failed';
      });
    }

    // setState(() {//Model
    //   //_foodList = [];
    //   // _foodList = output['data'].map<FoodItem>((item) {
    //   //   return FoodItem.formJson(item);
    //   // }).toList();
    //
    //   // output['data'].forEach((item){
    //   //   print(item['name']+ ' ราคา '+item['price'].toString());
    //   //   var foodItem = FoodItem.formJson(item);
    //   //   _foodList!.add(foodItem);
    //   // });
    //
    // });
  }

  Widget _buildListItem(BuildContext context, int index) {
    var football = _FootballList![index];
    return Card(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              football.flagImage,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(football.team),
            Column(

              children: [
                SizedBox(width: 400.0,),
                ElevatedButton(onPressed: () {

                },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xffa21026)),
                    child: Text('Vote')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
