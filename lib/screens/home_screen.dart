import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bus_provider.dart';
import '../widgets/route_card.dart';
import 'route_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Express', 'Normal', 'Long Distance', 'Favorites'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: _currentIndex == 0 ? _buildHome(provider) : const FavoritesScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          border: Border(top: BorderSide(color: const Color(0xFFc9a84c).withOpacity(0.3))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFc9a84c),
          unselectedItemColor: Colors.grey[600],
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Routes'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(BusProvider provider) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: const Color(0xFF0a0a0a),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFc9a84c).withOpacity(0.2),
                    const Color(0xFF0a0a0a),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFc9a84c).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.4)),
                            ),
                            child: const Text('🚌', style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SL Bus Tracker', style: TextStyle(color: Color(0xFFc9a84c), fontSize: 20, fontWeight: FontWeight.w800)),
                              Text('🇱🇰 Sri Lanka', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Find Your Bus', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                      const Text('Where are you going?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) => context.read<BusProvider>().setSearch(v),
                    decoration: InputDecoration(
                      hintText: 'Search routes, cities, stops...',
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                context.read<BusProvider>().setSearch('');
                              })
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Filter chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = provider.selectedFilter == _filters[i];
                      return GestureDetector(
                        onTap: () => context.read<BusProvider>().setFilter(_filters[i]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFFc9a84c) : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? const Color(0xFFc9a84c) : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Text(
                            _filters[i],
                            style: TextStyle(
                              color: selected ? Colors.black : Colors.grey[400],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    _statChip('${provider.routes.length}', 'Routes'),
                    const SizedBox(width: 10),
                    _statChip('${provider.favoriteIds.length}', 'Favorites'),
                    const SizedBox(width: 10),
                    _statChip('8', 'Cities'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Routes list
        provider.routes.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text('No routes found', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                      const SizedBox(height: 6),
                      Text('Try a different search', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => RouteCard(
                      route: provider.routes[index],
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => RouteDetailScreen(route: provider.routes[index]),
                      )),
                    ),
                    childCount: provider.routes.length,
                  ),
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _statChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Text(value, style: const TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}