import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// AIzaSyD8diOpPTB6BHVyeQYmklNH17iVKmFPfWA for clud
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterConfig.loadEnvVariables();
  await Supabase.initialize(
    url: 'https://uuwvoacxkttmhkvgtphr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1d3ZvYWN4a3R0bWhrdmd0cGhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU2NzM1MzksImV4cCI6MTk5MTI0OTUzOX0.etMt9Q5UZ2eTWFnGmaXORozC3Ar0ioFl9nrWHPXxy8g',
  );

  runApp(const MyApp());
}
// final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final supabase = Supabase.instance.client;
  final _future =
      Supabase.instance.client.from('t1').select<List<Map<String, dynamic>>>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            FloatingActionButton(onPressed: () async {
              await supabase.from('t1').insert({'b1': 'The Shire'});
            }),
            Expanded(child: GoogleMap(initialCameraPosition: _kGooglePlex)),
            Expanded(
              child: Container(
                color: Colors.red,
                // width: 200,
                // height: 200,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final countries = snapshot.data!;
                    return ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: ((context, index) {
                        final country = countries[index];
                        return ListTile(
                          title: Text(country['b1']),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
