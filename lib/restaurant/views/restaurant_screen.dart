import 'package:delivery_app_tutorial/common/constants/data.dart';
import 'package:delivery_app_tutorial/common/dio/dio.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/repository/restaurant_repository.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<Restaurant>> paginationRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storage: storage));

    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // final Response res = await dio.get('http://$ip/restaurant',
    //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    final res =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder(
            future: paginationRestaurant(),
            builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final pItem = snapshot.data![index];

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RestaurantDetailScreen(
                        id: pItem.id,
                      ),
                    )),
                    child: RestaurantCard.fromModel(restaurant: pItem),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              );
            },
          ),
        ),
      ),
    );
  }
}
