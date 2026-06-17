import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bus_provider.dart';
import '../widgets/route_card.dart';
import 'route_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusProvider>();
    final favorites = provider.favoriteRoutes;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('❤️ Favorites', style: TextStyle(color: Color(0xFFc9a84c), fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${favorites.length} saved routes', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 20),
            favorites.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('💔', style: TextStyle(fontSize: 56)),
                          const SizedBox(height: 14),
                          const Text('No favorites yet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Tap ❤️ on any route to save it', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, i) => RouteCard(
                        route: favorites[i],
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => RouteDetailScreen(route: favorites[i]),
                        )),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}