

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renmoney_test/models/city.dart';
import 'package:renmoney_test/models/weather.dart';
import 'package:renmoney_test/ui/home/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = HomeViewModel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
        create:(_) => _viewModel,
        child: Consumer<HomeViewModel>(
          builder: (_, viewModel, __){
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16
                  ),
                  child: DropdownButton<City>(
                    hint: const Text("Select a city"),
                    value: viewModel.selectedCities.isNotEmpty ? viewModel.selectedCities[0] : null,
                    items: viewModel.cities.map((City city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: (City? newCity) {
                      if (newCity != null) {
                        viewModel.addCity(newCity);
                      }
                    },
                    isExpanded: true,
                    padding: const EdgeInsets.all(10),
                    elevation: 0,

                  ),
                ),
                Builder(
                  builder: (context) {
                    // error state
                    if(!viewModel.fetchWeatherState && viewModel.fetchWeatherError != null){
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 50
                        ),
                        child: Center(
                          child: Text(
                              "${viewModel.fetchWeatherError}",
                          ),
                        ),
                      );
                    }

                    // busy state
                    if(viewModel.fetchWeatherState){
                      return const Padding(
                        padding: EdgeInsets.only(
                            top: 50
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    // empty state
                    if(viewModel.weatherData.isEmpty){
                      return const Padding(
                        padding: EdgeInsets.only(
                          top: 50
                        ),
                        child: Center(
                          child: Text(
                            "You are yet to select city"
                          ),
                        ),
                      );
                    }

                    // loaded state
                    return CarouselSlider.builder(
                      itemCount: viewModel.weatherData.length,
                      itemBuilder: (_, index, __) {
                        Weather weather = viewModel.weatherData.elementAt(index);
                        City city = viewModel.selectedCities.elementAt(index);
                        return Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20
                          ),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(city.name, style: const TextStyle(fontSize: 16)),
                                Text(weather.main ?? "", style: const TextStyle(fontSize: 24)),
                                Text('${weather.temperature}°C', style: const TextStyle(fontSize: 24)),
                                Text(weather.description ?? "", style: const TextStyle(fontSize: 18)),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 25
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent
                                    ),
                                    onPressed: () => viewModel.removeCity(city),
                                    child: const Text('Remove', style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 330,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                    );
                  }
                ),
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50
                  ),
                  child: ElevatedButton(
                    onPressed: viewModel.fetchWeatherForCurrentLocation,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Get Your Location Temp', textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                Center(
                  child: Text(
                    viewModel.currentWeatherLocation == null ? "Tap button to get current weather of your location": "${viewModel.currentWeatherLocation?.temperature}°C",
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}